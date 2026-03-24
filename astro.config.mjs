// @ts-check

import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';
import { defineConfig } from 'astro/config';
import remarkGfm from 'remark-gfm';
import rehypeRaw from 'rehype-raw';

// https://astro.build/config
export default defineConfig({
	site: 'https://blog.sportsflow.co.kr',
	integrations: [mdx(), sitemap()],
	markdown: {
		remarkPlugins: [remarkGfm],
		rehypePlugins: [rehypeRaw],
	},
});
