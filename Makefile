.PHONY: dev dev-stop prod prod-stop clean

dev: clean ## Start dev server (localhost:1313, live reload, drafts)
	docker compose --profile dev up -d --force-recreate

dev-stop: ## Stop dev server
	docker compose --profile dev down

prod: ## Start production server (localhost:8080, nginx)
	docker compose --profile prod up -d --build --force-recreate

prod-stop: ## Stop production server
	docker compose --profile prod down

clean: ## Remove Hugo build artifacts
	rm -rf public/ resources/_gen/
