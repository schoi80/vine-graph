# AGENTS: Neo4j Ingestion Scripts

**Context:** Cypher / Neo4j / APOC / Data Engineering

## OVERVIEW
The source of truth for the graph database structure and data ingestion pipeline using idempotent Cypher scripts.

## STRUCTURE
- `index.cypher`: Root file defining schema indexes and fulltext search capabilities.
- `nodes/`: Primary entity creation (e.g., `Book`, `Person`, `Place`, `Verse`).
- `relationships/`: Linkage logic connecting existing nodes (e.g., `Book-[:CONTAINS]->Chapter`).
- `patch/`: Post-ingestion updates, localizations (Korean names), and data fixes.

## WHERE TO LOOK (Order of Operations)
Execution order is **CRITICAL** for data integrity. Follow this sequence exactly:
1. **`index.cypher`**: Setup indexes first to optimize `MERGE` operations.
2. **`nodes/*.cypher`**: Load all base entities.
3. **`relationships/*.cypher`**: Connect nodes (requires nodes to exist).
4. **`patch/*.cypher`**: Apply final corrections and metadata.

## CONVENTIONS
- **Idempotency**: ALWAYS use `MERGE` instead of `CREATE` to allow safe re-runs.
- **Data Fetching**: Scripts use `apoc.load.json(url)` to pull data from GitHub raw URLs.
- **Variable Scoping**: Define the source URL at the top using `WITH "..." AS url`.
- **Property Updates**: Use `SET n.prop = value` for properties to ensure they stay up to date.
- **Indexing**: All `id` fields must have an index (defined in `index.cypher`).

## ANTI-PATTERNS
- **No Hardcoded Data**: Do not embed large datasets in Cypher; fetch from `data/` via URL.
- **No `CREATE`**: Avoid `CREATE` as it causes duplicate nodes on script re-execution.
- **Strict Dependencies**: Never run `relationships/` before `nodes/` are fully populated.
- **No Manual Edits**: Do not modify the database state manually; update the scripts and re-run.
