CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/places.json' AS url
   CALL apoc.load.json(url) YIELD value
   RETURN value",
  "MERGE (p:Place {id: value.id})
   SET p.placeId = value.fields.placeID,
       p.name = value.fields.displayTitle,
       p.latitude = toFloat(value.fields.latitude),
       p.longitude = toFloat(value.fields.longitude),
       p.precision = value.fields.precision,
       p.featureType = value.fields.featureType,
       p.description = value.fields.dictionaryText,
       p.source = CASE WHEN NOT value.fields.recogitoUri IS NULL
                    THEN value.fields.recogitoUri
                    ELSE 'https://openbible.info/geo'
                  END,
       p.slug = value.fields.slug,
       p.status = value.fields.status,
       p.comment = value.fields.comment",
  {batchSize: 1000, iterateList: true, parallel: false}
);
