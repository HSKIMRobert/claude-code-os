# 스레드 소개글 — Claude Code OS (CCO)

(아래 본문을 그대로 복사 — 한국 개발자 커뮤니티 / Threads / X / 카톡 오픈채팅 등에)

---

**🟡 Claude Code OS — USB 하나로 끝나는 AI 컴퓨터**

솔직히 너무 잘 작동해서 놀랄 지경입니다.

번거롭게 OS 깔고, 드라이버 잡고, Node 깔고, npm install 하고, Claude Code 설치하고 — 그런 거 다 필요 없습니다. **USB 만 꽂으면** 어느 PC, 어느 노트북이든 부팅 30초 만에 Claude Code 가 떠 있습니다. ASUS X515 같은 신형부터 Samsung NT900X3A 같은 13년 묵은 노트북까지, 다 됩니다.

설정도 USB 에 저장됩니다. Wi-Fi 비번 한 번 입력하면 다음 부팅에서 자동 연결. OAuth 인증 한 번이면 끝. 작업한 파일도 그대로 살아있습니다. 리부팅해도 설정이 사라지지 않습니다 (Ventoy persistence).

**핵심 메시지** — 이제 사람이 마우스로 일일이 직접 클릭하지 말고, 클로드 코드에게 "해달라" 고 다 맡기세요.
- "이 폴더 정리해줘"
- "이 PDF 표 엑셀로 만들어줘"
- "이메일 자동 답장 봇 만들어줘"
- "이 Excel 의 회계 항목들 분류해줘"

말로 시키면 알아서 해줍니다. 한글 입력기 (ibus-hangul) 도 박혀 있어서 Shift+Space 로 한/영 토글, 한글 메뉴, KST 시간대 — 한국 사용자에 맞춰 다 설정해 두었습니다.

## 어떻게 시작?

1. **USB 8 GB 이상** 준비
2. [Ventoy](https://www.ventoy.net/) 으로 USB 굽기 (한 번만)
3. [GitHub Release](https://github.com/Hostingglobal-Tech/claude-code-os/releases) 에서 ISO 두 part 다운 + 합치기 (Windows: `copy /b part1+part2 iso`, Linux: `cat part1 part2 > iso`)
4. USB 의 root 에 ISO + persistence dat 복사
5. 어떤 PC 든 USB 부팅 → 30초 후 AI 프롬프트

## 스펙

- Linux Mint 21.3 XFCE (Ubuntu 22.04 LTS jammy 호환)
- Anthropic claude-code (Node 20 LTS)
- Firefox + Wi-Fi GUI (NetworkManager + nm-applet)
- ibus-hangul (EN+KO 자동 등록, Shift+Space 토글)
- ko_KR.UTF-8 + Asia/Seoul timezone
- D2Coding 폰트 + Noto CJK KR (메뉴 가독성)
- Mint-Y-Dark-Aqua 테마 + 커스텀 colorblind-safe wallpaper
- Ventoy `casper-rw` persistence 매핑

## 보안

샌드박스 아닙니다. claude 가 root 권한 + 풀 네트워크 접근 가집니다. 중요한 데이터 있는 PC 에는 띄우지 마세요. **LiveUSB 라 호스트 디스크는 건드리지 않습니다** — USB 안에서만 작업. USB 분실 = 데이터 노출 위험. 분실 시 `cco-persistence.dat` 만 지우면 초기화.

## GitHub

🔗 https://github.com/Hostingglobal-Tech/claude-code-os

오픈소스 (Apache-2.0). 직접 빌드도 가능하고, 빌드 스크립트 (`build-mint.sh`) 한 번 보시면 어떤 패키지 박혔는지 다 보입니다. 환경에 맞게 fork 해서 자기 wallpaper / 자기 입력기 박은 커스텀 ISO 도 만들 수 있습니다.

---

#claude #claudecode #ai #linux #liveusb #mint #productivity #한국개발자
