# Archive — Alpine v1.0.x

이 폴더는 v1.0.x 시리즈 (Alpine Linux 3.20 base) 의 **빌드 스크립트 보존본** 입니다. v2.0 부터 Linux Mint 21.3 XFCE base 로 전환되어 더 이상 유지보수되지 않습니다.

| 파일 | 용도 (당시) |
|---|---|
| `build-rootfs.sh` | Alpine apk 으로 chroot rootfs 구성 |
| `build-iso.sh` | initramfs `/init` 패치 + ISO 빌드 |

## 폐기 이유

v1.0.20 까지는 동작했으나 v1.0.27~v1.0.36 에서 squashfs+overlayfs 회귀가 누적:
- ASUS X515 — 저해상도 vesa fallback + 키보드/마우스 먹통 (mesa-dri-gallium / linux-firmware 부재)
- Samsung NT900X3A — X 윈도우 화면 미표시
- v1.0.36 — `localhost login:` 프롬프트에서 진행 X (Alpine init line 986 의 default switch_root 가 patch 보다 먼저 실행)

사장님 결정 (2026-05-06): **Alpine 폐기, Linux Mint 21.3 XFCE 베이스로 전환**.

Mint 베이스 = Ubuntu 22.04 LTS jammy 호환 + linux-firmware 풀세트 + nm-applet Wi-Fi GUI + Firefox 내장.

자세한 v2.0 빌더는 repo root 의 `build-mint.sh` 참조.
