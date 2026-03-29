#!/usr/bin/env bash
set -euo pipefail

# SportsFlow 블로그 - 매일 아침 자동 글 작성 + 인스타그램 콘텐츠 생성
# 크론: 0 7 * * 1-5 (월~금 07:00 KST)

export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

BLOG_DIR="/home/mint/workspace/sports/blog"
INSTA_DIR="/home/mint/workspace/sports/marketing/instagram"
LOG_FILE="$BLOG_DIR/scripts/post.log"
CLAUDE="/home/mint/.local/bin/claude"
TODAY=$(date '+%Y-%m-%d')

cd "$BLOG_DIR"

echo "$(date '+%Y-%m-%d %H:%M:%S') - 블로그 글 작성 시작" >> "$LOG_FILE"

$CLAUDE -p "
당신은 SportsFlow 스포츠 블로그 작성자입니다.

/home/mint/workspace/sports/blog/src/content/blog/ 디렉토리에 오늘 날짜의 새 블로그 글을 작성하세요.

규칙:
1. 파일명: 영문 kebab-case (예: tennis-serve-rules.md)
2. 기존 글과 주제가 겹치면 안 됨 - 먼저 기존 글 목록을 확인할 것
3. SportsFlow 지원 종목 중심: 마라톤, 걷기, 트레일런, 자전거, 수영, 철인3종, 풋살, 축구, 농구, 야구, 배구, 골프, 테니스, 배드민턴
4. 카테고리: 스포츠 규칙, 스포츠 역사, 국내 대회 소식, 스포츠 팁/가이드 중 택 1
5. 2026년 최신 정보 기준
6. 본문 2,000자 이상
7. Unsplash 이미지 3개 이상 (https://images.unsplash.com/photo-... 형태, 반드시 curl로 200 응답 확인)
8. frontmatter: title, description, category, pubDate(오늘 날짜), heroImage
9. 마크다운 bold 규칙: **bold** 안에 괄호/따옴표를 넣지 말 것
10. 작성 후 git add, commit, push 실행

실행하세요.
" --allowedTools "Bash,Read,Write,Glob,Grep" >> "$LOG_FILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 블로그 글 작성 완료" >> "$LOG_FILE"

# ─── 인스타그램 카드 이미지 생성 ───────────────────────────────────
echo "$(date '+%Y-%m-%d %H:%M:%S') - 인스타그램 콘텐츠 생성 시작" >> "$LOG_FILE"

$CLAUDE -p "
당신은 SportsFlow 인스타그램 카드 뉴스 제작자입니다.

[Step 1] 오늘 작성된 블로그 글 확인
- /home/mint/workspace/sports/blog/src/content/blog/ 에서 오늘($TODAY) pubDate인 글을 찾아 읽으세요.

[Step 2] 인스타그램 슬라이드 10장 생성
- 경로: /home/mint/workspace/sports/marketing/instagram/posts/$TODAY-{주제}/
- 파일: slide-01.html ~ slide-10.html
- 공통 CSS: /home/mint/workspace/sports/marketing/instagram/shared-style.css (link 태그로 참조, 상대경로 ../../shared-style.css)

슬라이드 구성:
1장: 제목 슬라이드 - 블로그 제목을 크게, 호기심 유발 질문이나 강렬한 헤드라인
2장: 핵심 요약 - 이 글에서 다루는 내용 3~4가지 요약
3~8장: 본문 핵심 내용 - 블로그 내용을 카드별로 나누어 요약 (각 카드에 핵심 포인트 1~2개씩)
9장: 정리/요약 - 핵심 내용 한눈에 보기
10장: CTA - 'SportsFlow에서 더 많은 스포츠 정보를 확인하세요' + sportsflow.co.kr + blog.sportsflow.co.kr

디자인 규칙:
- 1080x1080px (body width/height)
- shared-style.css의 .container, .top-bar, .logo-area, .series-badge, .bottom-bar, .page-indicator, .accent 등 기존 클래스 활용
- series-badge: 'NN / 10' 형식
- page-indicator: dot 10개, 현재 슬라이드의 dot에 active 클래스
- 로고: <img src=\"file:///home/mint/workspace/sports/sports-platform/app/assets/images/logo_256.png\">
- 폰트: Noto Sans KR (shared-style.css에서 import됨)
- 색상: 브랜드 그린(#00C471) 강조, 배경 화이트, 텍스트 #111/#333/#888
- 각 슬라이드마다 내용에 맞는 이모지 아이콘 사용
- 텍스트는 크고 읽기 쉽게 (모바일에서 볼 수 있도록 최소 18px)
- 한 슬라이드에 텍스트 너무 많이 넣지 말 것 (핵심만 간결하게)

[Step 3] 캡처 실행
node /home/mint/workspace/sports/marketing/instagram/capture.mjs $TODAY-{주제}

[Step 4] 캡션 파일 생성
- /home/mint/workspace/sports/marketing/instagram/posts/$TODAY-{주제}/caption.txt
- 인스타그램에 올릴 캡션 텍스트 작성
- 해시태그 포함 (#SportsFlow #스포츠 #종목해시태그)
- 블로그 링크 포함

실행하세요.
" --allowedTools "Bash,Read,Write,Glob,Grep" >> "$LOG_FILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 인스타그램 콘텐츠 생성 완료" >> "$LOG_FILE"

# ─── Remotion 렌더링 + Buffer 업로드 ──────────────────────────────
echo "$(date '+%Y-%m-%d %H:%M:%S') - Remotion 렌더링 + Buffer 업로드 시작" >> "$LOG_FILE"

INSTA_FOLDER=$(ls -d "$INSTA_DIR/posts/$TODAY-"* 2>/dev/null | head -1)
if [ -n "$INSTA_FOLDER" ]; then
  FOLDER_NAME=$(basename "$INSTA_FOLDER")
  cd "$INSTA_DIR"
  bash daily_upload.sh >> "$LOG_FILE" 2>&1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - 렌더링 + 업로드 완료: $FOLDER_NAME" >> "$LOG_FILE"
else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - 인스타그램 폴더 없음, 업로드 스킵" >> "$LOG_FILE"
fi
