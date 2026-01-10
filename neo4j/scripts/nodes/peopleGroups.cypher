CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/peopleGroups.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MERGE (p:PeopleGroup {id: value.id})
   SET p.name = value.fields.groupName",
  {batchSize: 1000, iterateList: true, parallel: false}
);
