WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/books.json" AS url
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

// Add Korean titles to Book nodes
WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/booksKr.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (b:Book {title: value.bookName})

WITH b, value
MERGE (t1:Translation {language: "ko", field: "title", text: value.bookNameKr})
ON CREATE SET t1.id = randomUUID()
MERGE (t1)-[:TRANSLATION_OF]->(b)

WITH b, value
MERGE (t2:Translation {language: "ko", field: "shortName", text: value.shortNameKr})
ON CREATE SET t2.id = randomUUID()
MERGE (t2)-[:TRANSLATION_OF]->(b);

// Add Korean titles to Testament nodes
MATCH (t:Testament {title: "Old Testament"})
WITH t
MERGE (tr:Translation {language: "ko", field: "title", text: "구약"})
ON CREATE SET tr.id = randomUUID()
MERGE (tr)-[:TRANSLATION_OF]->(t);

MATCH (t:Testament {title: "New Testament"})
WITH t
MERGE (tr:Translation {language: "ko", field: "title", text: "신약"})
ON CREATE SET tr.id = randomUUID()
MERGE (tr)-[:TRANSLATION_OF]->(t);
