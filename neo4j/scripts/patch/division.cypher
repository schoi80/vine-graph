// Add Korean titles to Division nodes

// Old Testament Divisions
MATCH (d:Division {title: "Pentateuch"})
SET d.titleKr = "모세오경";

MATCH (d:Division {title: "Historical"})
SET d.titleKr = "역사서";

MATCH (d:Division {title: "Poetry-Wisdom"})
SET d.titleKr = "시가서";

MATCH (d:Division {title: "Major Prophets"})
SET d.titleKr = "대선지서";

MATCH (d:Division {title: "Minor Prophets"})
SET d.titleKr = "소선지서";

// New Testament Divisions
MATCH (d:Division {title: "Gospels"})
SET d.titleKr = "복음서";

MATCH (d:Division {title: "Acts"})
SET d.titleKr = "사도행전";

MATCH (d:Division {title: "Pauline Epistles"})
SET d.titleKr = "바울서신";

MATCH (d:Division {title: "General Epistles"})
SET d.titleKr = "일반서신";

MATCH (d:Division {title: "Revelation"})
SET d.titleKr = "요한계시록";
