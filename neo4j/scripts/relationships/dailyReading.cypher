CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/dailyReading2026.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MATCH (d:DailyReading {id: value.id})
   WITH d, value
   UNWIND value.osisRefs AS ref
   MATCH (c:Chapter {osisRef: ref})
   MERGE (c)-[:READ_ON]->(d)",
  {batchSize: 1000, iterateList: true, parallel: false}
);
