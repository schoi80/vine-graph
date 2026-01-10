WITH "https://raw.githubusercontent.com/schoi80/vine-graph/master/data/json/chapters.json" AS url
CALL apoc.load.json(url) YIELD value
MERGE (c:Chapter {id: value.id})
SET c.osisRef = value.fields.osisRef,
    c.chapterNum = toInteger(value.fields.chapterNum),
    c.slug = value.fields.slug;
