#!/usr/bin/make -f

# Load environment variables from .env
-include .env
export

NEO4J_SCRIPTS_DIR=neo4j/scripts

# Defaults (override via env or make vars)
NEO4J_URI ?= neo4j://localhost:7687
NEO4J_USERNAME ?= neo4j
NEO4J_PASSWORD ?= hellobible
NEO4J_DATABASE ?= neo4j

# Use Java 21 for cypher-shell (required by Neo4j)
CYPHER := cypher-shell -a "${NEO4J_URI}" -u "${NEO4J_USERNAME}" -p "${NEO4J_PASSWORD}" -d "${NEO4J_DATABASE}"

.PHONY: up down restart run-scripts run-scripts-docker check-cypher \
	install dev build start

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

# Run scripts using cypher-shell
init-graphdb: check-cypher
	@echo "Running index script..."
	@$(CYPHER) --file $(NEO4J_SCRIPTS_DIR)/index.cypher || exit 1
	@echo "Running node scripts..."
	@for script in $(NEO4J_SCRIPTS_DIR)/nodes/*.cypher; do \
		echo "Running $$script..."; \
		$(CYPHER) --file "$$script" || exit 1; \
	done
	@echo "Running relationship scripts..."
	@for script in $(NEO4J_SCRIPTS_DIR)/relationships/*.cypher; do \
		echo "Running $$script..."; \
		$(CYPHER) --file "$$script" || exit 1; \
	done
	@echo "Running patch scripts..."
	@for script in $(NEO4J_SCRIPTS_DIR)/patch/*.cypher; do \
		echo "Running $$script..."; \
		$(CYPHER) --file "$$script" || exit 1; \
	done
	@echo "All scripts completed successfully!"

check-cypher:
	@command -v cypher-shell >/dev/null 2>&1 || { echo "ERROR: cypher-shell not found. Install Neo4j CLI or use 'make run-scripts-docker'."; exit 1; }

install:
	@echo "Installing dependencies..."
	cd src && npm install

dev: install
	@echo "Starting development server..."
	cd src && npm run dev

build: install
	@echo "Building app for production..."
	cd src && npm run build

start:
	@echo "Starting app..."
	cd src && npm run start
