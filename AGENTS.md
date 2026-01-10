# PROJECT KNOWLEDGE BASE

**Generated:** 2026-01-10
**Context:** Node.js (Apollo/GraphQL) + Neo4j (Cypher) + Docker

## OVERVIEW
A GraphQL service (`src/`) wrapping a Neo4j graph database (`neo4j/`) populated with biblical data. It uses `@neo4j/graphql` to auto-generate the API from the schema.

## STRUCTURE
```
.
├── src/                  # GraphQL API Server (Self-contained Node project)
├── neo4j/
│   ├── scripts/          # Cypher ingestion scripts (The "Source of Truth" for data)
│   └── data/             # [WARNING] Committed DB binaries (exclude from edits)
├── data/                 # Raw JSON/CSV datasets (Read-only)
├── scripts/              # Python data generation utilities
├── Makefile              # Primary orchestrator (build, dev, init-graphdb)
└── docker-compose.yml    # Neo4j + APOC configuration
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| **Schema Definition** | `src/schema.graphql` | Defines types & custom `@cypher` directives |
| **API Logic** | `src/index.js` | Server setup, auth, & driver config |
| **Data Ingestion** | `neo4j/scripts/` | Idempotent Cypher scripts (Nodes -> Rels -> Patch) |
| **Orchestration** | `Makefile` | Use `make init-graphdb` or `make up` |

## CONVENTIONS
- **Ingestion Order**: STRICTLY `index.cypher` → `nodes/` → `relationships/` → `patch/`.
- **Idempotency**: All Cypher scripts must use `MERGE` to prevent duplicates.
- **Nested Config**: API config (`.env`, `package.json`) lives in `src/`, NOT root.
- **Data Fetching**: Cypher scripts fetch raw data from GitHub `raw` URLs (or local mappings).

## ANTI-PATTERNS (THIS PROJECT)
- **NO Direct DB Edits**: Always use the `neo4j/scripts` pipeline.
- **NO `src` Prefix**: `npm` commands run INSIDE `src`. `Makefile` handles the `cd src`.
- **NO Manual Driver Init**: Use the configured instance in `src/index.js` (`disableLosslessIntegers: true`).
- **DO NOT Commit**: `neo4j/data/` (runtime binaries) or `node_modules`.

## COMMANDS
```bash
# Start Environment
make up               # Start Neo4j (Docker)

# Data Ingestion (Required first time)
make init-graphdb     # Run all Cypher scripts (requires local cypher-shell)
# OR
make run-scripts-docker # Run via Docker

# Development
make dev              # Start GraphQL server (Hot-reload)
```

## NOTES
- **Neo4j Version**: 2025.11-core with APOC plugin.
- **Raw Data**: `data/` contains large JSON/CSV files used by the ingestion scripts.
