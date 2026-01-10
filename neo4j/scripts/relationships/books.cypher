WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/books.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (b:Book {id: value.id})
WITH b, value

FOREACH(chapter IN value.fields.chapters |
  MERGE (c:Chapter {id: chapter})
  MERGE (b)-[:CONTAINS]->(c)
);
