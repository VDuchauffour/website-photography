.PHONY: dev dev-stop clean

dev: clean
	docker compose --profile dev up -d --force-recreate

dev-stop:
	docker compose --profile dev down

clean:
	rm -rf public/ resources/_gen/
