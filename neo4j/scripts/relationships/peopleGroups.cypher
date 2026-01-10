WITH "https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/peopleGroups.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (g:PeopleGroup {id: value.id})
WITH g, value

FOREACH (member IN value.fields.members |
  MERGE (m:Person {id: member})
  MERGE (m)-[:MEMBER_OF]->(g)
);
