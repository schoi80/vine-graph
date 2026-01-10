WITH "https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/dailyReading2026.json" AS url
CALL apoc.load.json(url) YIELD value
MERGE (d:DailyReading {id: value.id})
SET d.date = date(value.id);
