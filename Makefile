up:
	docker-compose up -d

down:
	docker-compose down

article:
	docker-compose run zenn-cli new:article

book:
	docker-compose run zenn-cli new:book

shell:
	docker-compose run --entrypoint bash zenn-cli

update:
	@jq ".dependencies[\"zenn-cli\"] = \"`docker-compose run --entrypoint npm zenn-cli show zenn-cli version | tr -d '\r'`\"" CLI/package.json > CLI/tmp.json
	@mv CLI/tmp.json CLI/package.json
	docker-compose build