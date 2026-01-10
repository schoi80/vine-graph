// Add Korean titles to Testament nodes
MATCH (t:Testament {title: "Old Testament"})
SET t.titleKr = "구약";

MATCH (t:Testament {title: "New Testament"})
SET t.titleKr = "신약";
