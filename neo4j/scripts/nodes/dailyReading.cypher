WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/dailyReading2026.json" AS url
CALL apoc.load.json(url) YIELD value
MERGE (d:DailyReading {id: value.id})
SET d.date = date(value.id);
