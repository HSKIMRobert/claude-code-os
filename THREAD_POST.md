# 스레드 소개글 — Claude Code OS (CCO)

(아래 본문을 그대로 복사 — 한국 개발자 커뮤니티 / Threads / X / 카톡 오픈채팅 등에)

---

**🟡 싹 다 바꿨습니다.**

AI 한 번 쓰자고 OS 깔고, 드라이버 잡고, Node 깔고, npm install 하고, 로그인 인증하고 — 이 짓 더 안 해도 됩니다.

**USB 하나만 꽂으면 끝.**

부팅 30초 만에 Claude Code 가 떠 있습니다. 어느 PC 든, 어느 노트북이든. ASUS X515 같은 신형부터 Samsung NT900X3A 같은 13년 묵은 노트북까지 — 다 됩니다. Wi-Fi 자동 잡히고, 한글 입력기 박혀 있고, OAuth 한 번이면 끝.

솔직히 너무 잘 작동해서 직접 만든 저도 놀랄 지경입니다.

---

**리부팅해도 설정이 안 사라집니다.**

USB 안에 작업물·Wi-Fi 비번·OAuth 토큰·설치한 패키지 전부 영구 저장. 회의실 PC, 카페 노트북, 호텔 데스크탑 — 어디서든 같은 USB 꽂으면 **내 환경 그대로**. 호스트 디스크는 건드리지도 않습니다. 빼고 나오면 흔적 0.

---

**이제 마우스로 직접 클릭 안 해도 됩니다.**

다 클로드한테 맡기세요.

- "이 폴더 정리해줘"
- "이 PDF 표 전부 엑셀로 뽑아줘"
- "이메일 자동 답장 봇 만들어줘"
- "이 영수증 사진들 항목별 분류해서 합계 내줘"
- "이 사이트 매시간 모니터링하다가 가격 떨어지면 알려줘"

말로 시키면 합니다. 한글 그대로 시키세요. Shift+Space 한/영 토글까지 박혀 있습니다.

---

**스펙**

- Linux Mint 21.3 XFCE (Ubuntu 22.04 LTS jammy 호환 — 모든 .deb / PPA 동작)
- Anthropic claude-code (Node 20 LTS) + Firefox 내장
- ibus-hangul (EN+KO 자동 등록), ko_KR.UTF-8, Asia/Seoul, D2Coding
- Mint-Y-Dark-Aqua + colorblind-safe wallpaper
- Ventoy persistence (`casper-rw` 매핑)

---

**시작 방법 (5분)**

1. USB 8 GB+ 준비 → [Ventoy](https://www.ventoy.net/) 로 한 번 굽기
2. [GitHub Release](https://github.com/Hostingglobal-Tech/claude-code-os/releases) 에서 ISO part1 + part2 다운로드, 합치기
   - Linux: `cat part1 part2 > iso`
   - Windows: `copy /b part1+part2 iso`
3. USB 의 root 에 ISO + persistence dat 복사
4. 어떤 PC 든 USB 꽂고 부팅 → 30초 후 AI 프롬프트

---

**보안**

샌드박스 아닙니다. claude 가 root + 풀 네트워크. 중요한 데이터 있는 PC 에 띄울 거면 USB 안에서만 작업하세요 (호스트 디스크 안 건드림). USB 분실 = 토큰 노출. 분실 시 `cco-persistence.dat` 만 지우면 초기화.

---

🔗 **https://github.com/Hostingglobal-Tech/claude-code-os**

오픈소스 (Apache-2.0). 빌드 스크립트 한 번 보시면 어떤 패키지 박혔는지 다 보입니다. fork 해서 자기 wallpaper / 자기 입력기 박은 커스텀 ISO 도 가능.

#claude #claudecode #ai #linux #liveusb #한국개발자
