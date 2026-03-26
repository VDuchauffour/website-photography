.PHONY: dev dev-stop clean

dev: clean ## Start dev server (localhost:1313, live reload, drafts)
	docker compose --profile dev up -d --force-recreate

dev-stop: ## Stop dev server
	docker compose --profile dev down

clean: ## Remove Hugo build artifacts
	rm -rf public/ resources/_gen/
