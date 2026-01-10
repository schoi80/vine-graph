WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/peopleGroups.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (g:PeopleGroup {id: value.id})
WITH g, value

FOREACH (member IN value.fields.members |
  MERGE (m:Person {id: member})
  MERGE (m)-[:MEMBER_OF]->(g)
);
