// Add Korean titles to Division nodes

// Old Testament Divisions
MATCH (d:Division {title: "Pentateuch"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "모세오경"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Historical"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "역사서"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Poetry-Wisdom"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "시가서"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Major Prophets"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "대선지서"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Minor Prophets"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "소선지서"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

// New Testament Divisions
MATCH (d:Division {title: "Gospels"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "복음서"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Acts"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "사도행전"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Pauline Epistles"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "바울서신"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "General Epistles"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "일반서신"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);

MATCH (d:Division {title: "Revelation"})
WITH d
MERGE (t:Translation {language: "ko", field: "title", text: "요한계시록"})
ON CREATE SET t.id = randomUUID()
MERGE (t)-[:TRANSLATION_OF]->(d);
