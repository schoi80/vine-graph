WITH "https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/booksKr.json" AS url
CALL apoc.load.json(url) YIELD value
MATCH (b:Book {title: value.bookName})
SET b.bookNameKr = value.bookNameKr,
    b.shortNameKr = value.shortNameKr;
