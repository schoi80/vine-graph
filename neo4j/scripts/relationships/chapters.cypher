CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/chapters.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MATCH (c:Chapter {id: value.id})
   WITH c, value

   FOREACH (verse IN value.fields.verses |
     MERGE (v:Verse {id: verse})
     MERGE (c)-[:CONTAINS]->(v)
   )

   FOREACH (writer IN value.fields.writer |
     MERGE (w:Person {id: writer})
     MERGE (w)-[:WROTE]->(c)
   )",
  {batchSize: 1000, iterateList: true, parallel: false}
);
