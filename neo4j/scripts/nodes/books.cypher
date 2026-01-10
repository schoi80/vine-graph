WITH "https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/books.json" AS url
CALL apoc.load.json(url) YIELD value
MERGE (t:Testament {title: value.fields.testament})
MERGE (d:Division {title: value.fields.bookDiv})
MERGE (b:Book {id: value.id})
SET b.osisRef = value.fields.osisName,
    b.bookOrder = toInteger(value.fields.bookOrder),
    b.shortName = value.fields.shortName,
    b.slug = value.fields.slug,
    b.title = value.fields.bookName
MERGE (t)-[:CONTAINS]-(d)
MERGE (t)-[:CONTAINS]-(b)
MERGE (d)-[:CONTAINS]-(b);
