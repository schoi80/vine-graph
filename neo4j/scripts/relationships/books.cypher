WITH "https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/books.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (b:Book {id: value.id})
WITH b, value

FOREACH(chapter IN value.fields.chapters |
  MERGE (c:Chapter {id: chapter})
  MERGE (b)-[:CONTAINS]->(c)
);
