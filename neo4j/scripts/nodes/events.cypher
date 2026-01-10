CALL apoc.periodic.iterate(
  "WITH 'https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/events.json' AS url
   CALL apoc.load.json(url) YIELD value
   WHERE value.id IS NOT NULL
   RETURN value",
  "MERGE (e:Event {id: value.id})
   SET e.eventID = value.fields.eventID,
       e.title = value.fields.title,
       e.startDate = CASE
         WHEN value.fields.startDate IS NOT NULL THEN
          CASE
            WHEN size(value.fields.startDate) <= 5 THEN
              CASE
                WHEN substring(value.fields.startDate, 0, 1) = '-' THEN
                  date('-' + apoc.text.lpad(substring(value.fields.startDate, 1), 4, '0') + '-01-01')
                ELSE
                  date(apoc.text.lpad(value.fields.startDate, 4, '0') + '-01-01')
              END
            ELSE date(value.fields.startDate)
          END
         ELSE null
       END,
       e.duration = value.fields.duration,
       e.sortKey = value.fields.sortKey",
  {batchSize: 1000, iterateList: true, parallel: false}
);
