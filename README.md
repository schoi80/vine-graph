# Vine GraphQL Service

A GraphQL API for the [Vine](https://github.com/schoi80/vine) project, built with Node.js, Apollo Server, and Neo4j. This service provides a graph-based interface to explore biblical data.

## Features

- **Neo4j GQL Integration**: Automatically generates GraphQL schema from Neo4j database.
- **Apollo Server**: High-performance GraphQL server.
- **Dockerized Neo4j**: Simple setup for the graph database.
- **Automated Seeding**: Makefile-driven database initialization.

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher)
- **Docker** and **Docker Compose**
- **Neo4j Cypher Shell** (optional, for local DB initialization)
- **Java 21** (required if using local `cypher-shell`)

---

## Getting Started

### 1. Clone and Install

```bash
git clone <repository-url>
cd vine-graph
make install
```

### 2. Set Up Neo4j

The easiest way to run Neo4j is via Docker.

```bash
make up
```
This will start Neo4j at `bolt://localhost:7687` with the username `neo4j` and password `hellobible`.

### 3. Initialize the Database

Once Neo4j is running, you need to seed the data and create indexes.

If you have `cypher-shell` installed locally:
```bash
make init-graphdb
```

Otherwise, run it via Docker:
```bash
make run-scripts-docker
```

### 4. Run the Service

Start the GraphQL server in development mode:

```bash
make dev
```

The server will be available at [http://localhost:4000](http://localhost:4000). You can access the GraphQL Playground at this address to run queries.

---

## Data Ingestion

The graph database is populated using Cypher scripts located in the `neo4j/scripts` directory. The ingestion process follows a strict order to ensure data integrity:

1.  **Indexes & Constraints**: `index.cypher` creates necessary unique constraints and indexes.
2.  **Nodes**: Scripts in `neo4j/scripts/nodes/` create the entities (e.g., Books, Chapters, Verses).
3.  **Relationships**: Scripts in `neo4j/scripts/relationships/` connect the nodes.
4.  **Patches**: Scripts in `neo4j/scripts/patch/` apply any final updates or corrections.

### Running Ingestion

You can run the full ingestion pipeline using **Local Shell** (`cypher-shell` must be installed):
    ```bash
    make init-graphdb
    ```

*Note: Running these scripts multiple times is idempotent as they use `MERGE` patterns.*

## Neo4j Installation Guidance

### Option A: Using Docker (Recommended)
This project comes with a `docker-compose.yml` file that configures Neo4j with the necessary plugins (APOC) and settings.

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. Run `make up`.
3. Access the Neo4j Browser at [http://localhost:7474](http://localhost:7474).

### Option B: Manual Installation (macOS)
If you prefer to run Neo4j natively:

1. Install Neo4j via Homebrew:
   ```bash
   brew install neo4j
   ```
2. Start the service:
   ```bash
   neo4j start
   ```
3. Install `cypher-shell` separately:
   ```bash
   brew install cypher-shell
   ```

### Option C: Neo4j Desktop
1. Download [Neo4j Desktop](https://neo4j.com/download/).
2. Create a new project and a database (version 2025.11 or similar).
3. Set the password to `hellobible` or update your `.env` file.
4. Install the **APOC** plugin from the database "Plugins" tab.

---

## Configuration

Environment variables are managed in `src/.env`. Copy the example file to get started:

```bash
cp src/.env.example src/.env
```

| Variable | Description | Default |
|----------|-------------|---------|
| `NEO4J_URI` | Neo4j Connection URI | `neo4j://localhost:7687` |
| `NEO4J_USERNAME` | Neo4j Username | `neo4j` |
| `NEO4J_PASSWORD` | Neo4j Password | `hellobible` |
| `PORT` | GraphQL Server Port | `4000` |

---

## Makefile Commands

- `make up`: Start Neo4j container.
- `make down`: Stop Neo4j container.
- `make init-graphdb`: Run initialization scripts (requires local `cypher-shell`).
- `make dev`: Start the GraphQL server with hot-reload.
- `make install`: Install Node.js dependencies.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
