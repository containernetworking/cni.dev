DOCKER_IMG = klakegg/hugo:0.80.0-ext
SERVER     = server --buildDrafts --buildFuture --disableFastRender --ignoreCache

yarn:
	yarn

serve:
	yarn
	hugo $(SERVER)

docker-serve:
	docker run --rm -it -v $(PWD):/src -p 1313:1313 $(DOCKER_IMG) $(SERVER)

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

# Link check code based on Luc Perkins etcd-io/website
# https://github.com/etcd-io/website/commit/5ed6c700096509c7b436de440e9cc72a8475fb0b#diff-76ed074a9305c04054cdebb9e9aad2d818052b07091de1f20cad0bbac34ffb52

clean:
	rm -rf public

link-checker-setup:
	# https://wjdp.uk/work/htmltest/
	curl https://htmltest.wjdp.uk | bash

run-link-checker:
	bin/htmltest

check-links: clean production-build link-checker-setup run-link-checker

