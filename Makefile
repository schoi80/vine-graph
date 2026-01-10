#!/usr/bin/make -f
# SHELL := /bin/bash

NEO4J_SCRIPTS_DIR=neo4j/scripts

# Defaults (override via env or make vars)
NEO4J_URI ?= neo4j://localhost:7687
NEO4J_USERNAME ?= neo4j
NEO4J_PASSWORD ?= hellobible
NEO4J_DATABASE ?= neo4j

# Use Java 21 for cypher-shell (required by Neo4j)
CYPHER := cypher-shell -a "${NEO4J_URI}" -u "${NEO4J_USERNAME}" -p "${NEO4J_PASSWORD}" -d "${NEO4J_DATABASE}"

.PHONY: up down restart run-scripts run-scripts-docker check-cypher \
	install-frontend dev build \
	docker-build docker-up \
	lint lint-fix format format-check typecheck quality pre-commit

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

# Run scripts using cypher-shell
run-scripts: check-cypher
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

# # Old behavior: run scripts inside Docker container
# run-scripts-docker:
# 	@echo "Running index script..."
# 	@docker compose exec -T neo4j cypher-shell -u neo4j -p hellobible < $(NEO4J_SCRIPTS_DIR)/index.cypher || exit 1
# 	@echo "Running node scripts..."
# 	@for script in $(NEO4J_SCRIPTS_DIR)/nodes/*.cypher; do \
# 		echo "Running $$script..."; \
# 		docker compose exec -T neo4j cypher-shell -u neo4j -p hellobible < $$script || exit 1; \
# 	done
# 	@echo "Running relationship scripts..."
# 	@for script in $(NEO4J_SCRIPTS_DIR)/relationships/*.cypher; do \
# 		echo "Running $$script..."; \
# 		docker compose exec -T neo4j cypher-shell -u neo4j -p hellobible < $$script || exit 1; \
# 	done
# 	@echo "Running patch scripts..."
# 	@for script in $(NEO4J_SCRIPTS_DIR)/patch/*.cypher; do \
# 		echo "Running $$script..."; \
# 		docker compose exec -T neo4j cypher-shell -u neo4j -p hellobible < $$script || exit 1; \
# 	done
# 	@echo "All scripts completed successfully!"

check-cypher:
	@command -v cypher-shell >/dev/null 2>&1 || { echo "ERROR: cypher-shell not found. Install Neo4j CLI or use 'make run-scripts-docker'."; exit 1; }

# install-frontend:
# 	@echo "Installing frontend dependencies..."
# 	cd frontend && npm install --legacy-peer-deps

# dev: install-frontend
# 	@echo "Starting integrated Next.js development server..."
# 	cd frontend && npm run dev

# build: install-frontend
# 	@echo "Building integrated app for production..."
# 	cd frontend && npm run build

# docker-build:
# 	@echo "Building production Docker image..."
# 	docker build -t bible-graph-app .

# docker-up:
# 	@echo "Starting production stack with integrated app..."
# 	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# # Code Quality Commands

# lint:
# 	@echo "Running ESLint..."
# 	cd frontend && npx eslint .

# lint-fix:
# 	@echo "Running ESLint with auto-fix..."
# 	cd frontend && npm run lint:fix

# format:
# 	@echo "Running Prettier to format code..."
# 	cd frontend && npm run format

# format-check:
# 	@echo "Checking code formatting..."
# 	cd frontend && npm run format:check

# typecheck:
# 	@echo "Running TypeScript compilation check..."
# 	cd frontend && npx tsc --noEmit

# quality: format lint typecheck
# 	@echo "All code quality checks passed!"

# pre-commit: format-check lint typecheck
# 	@echo "Pre-commit checks complete!"
