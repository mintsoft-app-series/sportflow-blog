export const SITE_TITLE = 'SportsFlow 블로그';
export const SITE_DESCRIPTION = '스포츠의 규칙, 역사, 국내 대회 소식과 뉴스를 전합니다.';

export const CATEGORY_SLUGS: Record<string, string> = {
  '스포츠 규칙': 'rules',
  '스포츠 역사': 'history',
  '국내 대회 소식': 'events',
  '스포츠 팁/가이드': 'tips',
};

export const SLUG_TO_CATEGORY: Record<string, string> = Object.fromEntries(
  Object.entries(CATEGORY_SLUGS).map(([k, v]) => [v, k])
);
