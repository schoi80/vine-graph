# PROJECT KNOWLEDGE BASE: src/

**Generated:** 2026-01-10
**Reason:** Independent Node.js Module (Apollo Server + @neo4j/graphql)

## OVERVIEW
An Apollo Server instance that provides a GraphQL API by mapping a Neo4j database to a GraphQL schema via `@neo4j/graphql`.

## STRUCTURE
```
src/
├── index.js            # Entry point (Apollo Server & Driver setup)
├── schema.graphql      # Type definitions with @neo4j directives
├── package.json        # Node metadata & scripts (run from this dir)
├── .env                # Local secrets (NEO4J_URI, password, PORT)
└── node_modules/       # Local dependencies
```

## WHERE TO LOOK
| File | Responsibility |
|------|----------------|
| **`index.js`** | Apollo Server config, Neo4j Driver init, and CORS/Context setup. |
| **`schema.graphql`** | The "Resolvers": Defines nodes, relationships, and `@cypher` logic. |
| **`.env`** | Connection strings and server port (ensure this exists). |
| **`package.json`** | Use `npm run dev` for hot-reloading (node --watch). |

## CONVENTIONS
- **Driver Config**: MUST use `disableLosslessIntegers: true` in `index.js` for JS number compatibility.
- **Auto-Resolvers**: Most resolvers are auto-generated. Only use `@cypher` directives for complex logic.
- **ES Modules**: This module uses `"type": "module"`. Use `import` syntax.
- **Local Config**: `package.json` and `.env` are specific to this directory, NOT the root.

## ANTI-PATTERNS
- **NO Manual Resolvers**: Avoid writing manual resolvers in `index.js` unless `@cypher` directives are insufficient.
- **NO Root-Level npm**: Do not run `npm` commands from the project root; `cd src` or use the `Makefile`.
- **NO Hardcoded Credentials**: Always use `process.env` for database connection details.
- **NO Schema Logic in JS**: Keep graph logic inside `schema.graphql` using Cypher strings.
