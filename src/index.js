import 'dotenv/config';
import { ApolloServer } from '@apollo/server';
import { startStandaloneServer } from '@apollo/server/standalone';
import { Neo4jGraphQL } from '@neo4j/graphql';
import neo4j from 'neo4j-driver';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Read GraphQL schema
const typeDefs = readFileSync(join(__dirname, 'schema.graphql'), 'utf-8');

// Create Neo4j driver instance with integer conversion
const driver = neo4j.driver(
  process.env.NEO4J_URI || 'neo4j://localhost:7687',
  neo4j.auth.basic(
    process.env.NEO4J_USERNAME || 'neo4j',
    process.env.NEO4J_PASSWORD || 'neo4j'
  ),
  {
    disableLosslessIntegers: true
  }
);

// Create Neo4j GraphQL instance
const neoSchema = new Neo4jGraphQL({ typeDefs, driver });

// Create Apollo Server
const server = new ApolloServer({
  schema: await neoSchema.getSchema(),
});

// Start the server
const { url } = await startStandaloneServer(server, {
  listen: { port: process.env.PORT || 4000 },
  context: async ({ req }) => ({ req }),
  cors: {
    origin: [
      'http://localhost:3000',
      'http://localhost:8080',
      'http://sages-m3.local:8080',
    ],
    credentials: true,
  },
});

console.log(`🚀 Server ready at ${url}`);
console.log(`📊 GraphQL Playground available at ${url}`);
