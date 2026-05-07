#!/bin/bash
# Build cco-alpine-vX.Y.Z.iso — patches Alpine standard ISO with squashfs+overlay init
#
# Output: cco-alpine-${VERSION}.iso (~930 MB)
#
# Prerequisites:
#   - cco-root.squashfs (from build-rootfs.sh)
#   - alpine-standard-3.20.3-x86_64.iso in current directory
#   - xorriso, cpio, gzip
set -e

VERSION="${1:-1.0.35}"
[ "$EUID" = 0 ] || { echo "Run with sudo." >&2; exit 1; }
[ -f cco-root.squashfs ] || { echo "cco-root.squashfs missing. Run build-rootfs.sh first." >&2; exit 1; }
[ -f alpine-standard-3.20.3-x86_64.iso ] || { echo "alpine-standard-3.20.3-x86_64.iso missing." >&2; exit 1; }

# 1. Extract upstream initramfs + boot menu
rm -rf alpine-extract initrd-extract
mkdir -p alpine-extract initrd-extract
xorriso -osirrox on -indev alpine-standard-3.20.3-x86_64.iso \
  -extract /boot alpine-extract/boot \
  -extract /efi alpine-extract/efi 2>/dev/null && xorriso -osirrox on -indev alpine-standard-3.20.3-x86_64.iso -extract /boot/modloop-lts alpine-extract/boot/modloop-lts 2>/dev/null || true

cd initrd-extract
gunzip -c ../alpine-extract/boot/initramfs-lts | cpio -idm 2>/dev/null
cd ..

# 2. Patch boot menu labels: "Linux lts" → "Claude Code OS"
sed -i 's/Linux lts/Claude Code OS/g; s/lts kernel/Claude Code OS/g; s/Alpine.*Linux/Claude Code OS/g' alpine-extract/boot/syslinux/syslinux.cfg
sed -i 's/Linux lts/Claude Code OS/g' alpine-extract/boot/grub/grub.cfg

# 3. Boot menu timeout (3 sec) + cmdline
sed -i 's/^TIMEOUT.*/TIMEOUT 30/g; s/^PROMPT.*/PROMPT 0/g' alpine-extract/boot/syslinux/syslinux.cfg
sed -i 's/set timeout=.*/set timeout=3/g' alpine-extract/boot/grub/grub.cfg
sed -i 's/quiet$/quiet usbdelay=0 rootdelay=0/g' alpine-extract/boot/syslinux/syslinux.cfg alpine-extract/boot/grub/grub.cfg

# 4. Patch /init — squashfs+overlay just before exec switch_root
INIT=initrd-extract/init
cp "$INIT" "${INIT}.bak"

sed -i '/^exec switch_root/i \
echo ""\
echo "  CCO v'"$VERSION"' (squashfs+overlay)"\
modprobe loop 2>/dev/null\
modprobe squashfs 2>/dev/null\
modprobe overlay 2>/dev/null\
SQ=""\
for D in /media/cdrom /media/sr0 /media/sda /media/sdb /media/sdc /.modloop /sysroot/media/cdrom /cdrom /run/medium /run/initramfs/medium; do\
  [ -f "$D/cco-root.squashfs" ] && SQ="$D/cco-root.squashfs" && break\
done\
[ -z "$SQ" ] && [ -f "$sysroot/media/cdrom/cco-root.squashfs" ] && SQ="$sysroot/media/cdrom/cco-root.squashfs"\
if [ -z "$SQ" ]; then\
  for dev in /dev/sr0 /dev/sr1 /dev/sda1 /dev/sda2 /dev/sda3 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/nvme0n1p1; do\
    [ -b "$dev" ] || continue\
    mkdir -p /cco-media\
    mount -o ro "$dev" /cco-media 2>/dev/null && {\
      [ -f /cco-media/cco-root.squashfs ] && SQ=/cco-media/cco-root.squashfs && break\
      umount /cco-media 2>/dev/null\
    }\
  done\
fi\
[ -z "$SQ" ] && SQ=$(find / -maxdepth 6 -name cco-root.squashfs 2>/dev/null | head -1)\
if [ -z "$SQ" ]; then echo "  no squashfs"; exec /bin/sh; fi\
echo "  Found: $SQ"\
mkdir -p /sysroot-lower /cco-rw\
mount -t squashfs -o loop,ro "$SQ" /sysroot-lower\
mount -t tmpfs -o size=4G tmpfs /cco-rw\
mkdir -p /cco-rw/upper /cco-rw/work\
umount $sysroot 2>/dev/null\
mount -t overlay overlay -o lowerdir=/sysroot-lower,upperdir=/cco-rw/upper,workdir=/cco-rw/work $sysroot\
mkdir -p $sysroot/dev $sysroot/dev/pts $sysroot/dev/shm $sysroot/proc $sysroot/sys $sysroot/run $sysroot/tmp\
mount -t devtmpfs dev $sysroot/dev 2>/dev/null\
mount -t devpts -o gid=5,mode=620 devpts $sysroot/dev/pts 2>/dev/null\
mount -t tmpfs shm $sysroot/dev/shm 2>/dev/null\
mount -t proc proc $sysroot/proc 2>/dev/null\
mount -t sysfs sys $sysroot/sys 2>/dev/null\
mount -t tmpfs run $sysroot/run 2>/dev/null\
mount -t tmpfs tmp $sysroot/tmp 2>/dev/null\
mkdir -p $sysroot/.modloop\
SQDIR=$(dirname "$SQ")\
ML=""\
[ -f "$SQDIR/boot/modloop-lts" ] && ML="$SQDIR/boot/modloop-lts"\
[ -z "$ML" ] && for D in /media/cdrom /run/medium /cdrom /run/initramfs/medium /media/sr0 /media/sda1 /media/sdb1 /cco-media; do [ -f "$D/boot/modloop-lts" ] && ML="$D/boot/modloop-lts" && break; done\
[ -z "$ML" ] && ML=$(find / -maxdepth 6 -name modloop-lts 2>/dev/null | head -1)\
[ -n "$ML" ] && mount -t squashfs -o loop,ro "$ML" $sysroot/.modloop 2>/dev/null && echo "  modloop: $ML"\
[ ! -e $sysroot/lib/modules ] && [ -d $sysroot/.modloop/modules ] && ln -sf /.modloop/modules $sysroot/lib/modules' "$INIT"

# 5. Repack initramfs
( cd initrd-extract && find . | cpio -o -H newc 2>/dev/null | gzip > "$PWD/../alpine-extract/boot/initramfs-lts" )

# 6. Add cco-root.squashfs to ISO root
cp cco-root.squashfs alpine-extract/cco-root.squashfs

# 7. Repack ISO
ISO_OUT="cco-alpine-v${VERSION}.iso"
rm -f "$ISO_OUT"
xorriso -indev alpine-standard-3.20.3-x86_64.iso -outdev "$ISO_OUT" \
  -boot_image any replay -volid 'Claude-Code-OS' \
  -map alpine-extract/boot/initramfs-lts /boot/initramfs-lts \
  -map alpine-extract/boot/syslinux /boot/syslinux \
  -map alpine-extract/boot/grub /boot/grub \
  -map alpine-extract/boot/modloop-lts /boot/modloop-lts \
  -map alpine-extract/efi /efi \
  -map alpine-extract/cco-root.squashfs /cco-root.squashfs \
  -commit 2>&1 | tail -3

ls -la "$ISO_OUT"
echo
echo "Done. Boot it:"
echo "  qemu-system-x86_64 -m 4096 -smp 2 -cdrom $ISO_OUT -boot d"
echo "Or for Ventoy persistence: see INSTALL.md"
