CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/versesKr.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MATCH (v:Verse {osisRef: value.osisRef})
   SET v.mdTextKr = value.mdTextKr",
  {batchSize: 5000, iterateList: true, parallel: false}
);
