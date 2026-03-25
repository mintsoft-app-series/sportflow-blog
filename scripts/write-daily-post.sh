#!/usr/bin/env bash
set -euo pipefail

# SportsFlow 블로그 - 매일 아침 자동 글 작성 스크립트
# 크론: 0 7 * * 1-5 (월~금 07:00 KST)

export PATH="$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

BLOG_DIR="/home/mint/workspace/sports/blog"
LOG_FILE="$BLOG_DIR/scripts/post.log"
CLAUDE="/home/mint/.local/bin/claude"

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
6. 본문 1,500자 이상
7. Unsplash 이미지 3개 이상 (https://images.unsplash.com/photo-... 형태, 반드시 curl로 200 응답 확인)
8. frontmatter: title, description, category, pubDate(오늘 날짜), heroImage
9. 작성 후 git add, commit, push 실행

실행하세요.
" --allowedTools "Bash,Read,Write,Glob,Grep" >> "$LOG_FILE" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - 완료" >> "$LOG_FILE"
