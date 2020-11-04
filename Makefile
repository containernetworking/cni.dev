yarn:
	yarn

serve:
	yarn
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender

production-build:
	hugo \
		--minify

non-production-build: ## Build the non-production site, which adds noindex headers to prevent indexing
	hugo --enableGitInfo

preview-build:
	hugo \
		--baseURL $(DEPLOY_PRIME_URL) \
		--buildDrafts \
		--buildFuture \
		--minify

open:
	open https://cncf-hugo-starter.netlify.com
