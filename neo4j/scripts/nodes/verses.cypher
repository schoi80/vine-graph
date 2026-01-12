CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/verses.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MERGE (v:Verse {id: value.id})
   SET v.osisRef = value.fields.osisRef,
       v.verseNum = toInteger(value.fields.verseNum),
       v.verseId = value.fields.verseID,
       v.text = value.fields.text",
  {batchSize: 5000, iterateList: true, parallel: false}
);

CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/versesKr.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MATCH (v:Verse {osisRef: value.osisRef})
   WITH v, value
   MERGE (t:Translation {id: v.id + '-ko'})
   SET t.language = 'ko',
       t.field = 'text',
       t.text = value.text
   MERGE (t)-[:TRANSLATION_OF]->(v)",
  {batchSize: 5000, iterateList: true, parallel: false}
);
