CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/bible-graph/master/neo4j/import/json/verses.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MERGE (v:Verse {id: value.id})
   SET v.osisRef = value.fields.osisRef,
       v.verseNum = toInteger(value.fields.verseNum),
       v.verseId = value.fields.verseID,
       v.verseText = value.fields.verseText,
       v.mdText = value.fields.mdText",
  {batchSize: 5000, iterateList: true, parallel: false}
);
