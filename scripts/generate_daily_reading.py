#!/usr/bin/env python3
"""
Generate dailyReading2026.json from daily_reading.txt
Parses Korean book abbreviations and chapter ranges into OSIS references.
"""

import json
from pathlib import Path

# Korean book abbreviation to OSIS name mapping
BOOK_MAP = {
    # Old Testament
    "창": "Gen",
    "출": "Exod",
    "레": "Lev",
    "민": "Num",
    "신": "Deut",
    "수": "Josh",
    "삿": "Judg",
    "룻": "Ruth",
    "삼상": "1Sam",
    "삼하": "2Sam",
    "열상": "1Kgs",
    "왕상": "1Kgs",
    "열하": "2Kgs",
    "왕하": "2Kgs",
    "대상": "1Chr",
    "대하": "2Chr",
    "스": "Ezra",
    "느": "Neh",
    "에": "Esth",
    "욥": "Job",
    "시": "Ps",
    "시편": "Ps",
    "잠": "Prov",
    "잠언": "Prov",
    "전": "Eccl",
    "아": "Song",
    "사": "Isa",
    "렘": "Jer",
    "애": "Lam",
    "겔": "Ezek",
    "단": "Dan",
    "호": "Hos",
    "욜": "Joel",
    "암": "Amos",
    "옵": "Obad",
    "욘": "Jonah",
    "미": "Mic",
    "나": "Nah",
    "합": "Hab",
    "습": "Zeph",
    "학": "Hag",
    "슥": "Zech",
    "말": "Mal",
    # New Testament
    "마": "Matt",
    "막": "Mark",
    "눅": "Luke",
    "요": "John",
    "행": "Acts",
    "롬": "Rom",
    "고전": "1Cor",
    "고후": "2Cor",
    "갈": "Gal",
    "엡": "Eph",
    "빌": "Phil",
    "골": "Col",
    "살전": "1Thess",
    "살후": "2Thess",
    "딤전": "1Tim",
    "딤후": "2Tim",
    "딛": "Titus",
    "몬": "Phlm",
    "히": "Heb",
    "약": "Jas",
    "벧전": "1Pet",
    "벧후": "2Pet",
    "요일": "1John",
    "요이": "2John",
    "요삼": "3John",
    "유": "Jude",
    "계": "Rev",
}


def parse_chapter_spec(spec: str) -> list[int]:
    """
    Parse chapter specification like '1', '1-3', '24-25' into list of chapter numbers.
    """
    spec = spec.strip()
    if "-" in spec:
        start, end = spec.split("-")
        return list(range(int(start), int(end) + 1))
    else:
        return [int(spec)]


def parse_line(line: str) -> tuple[int, int, list[str]]:
    """
    Parse a line from daily_reading.txt
    Returns: (month, day, list of OSIS refs)

    Format: month day book1 chapters1 book2 chapters2 ...
    Example: 1 1 창 1-3 마 1
    """
    tokens = line.strip().split()
    if len(tokens) < 3:
        raise ValueError(f"Invalid line: {line}")

    month = int(tokens[0])
    day = int(tokens[1])

    osis_refs = []
    i = 2
    while i < len(tokens):
        book_abbrev = tokens[i].strip()

        # Skip if it's a weekday marker or other non-book token
        if book_abbrev in ["금"]:
            i += 1
            continue

        if book_abbrev not in BOOK_MAP:
            raise ValueError(
                f"Unknown book abbreviation: {book_abbrev} in line: {line}"
            )

        osis_book = BOOK_MAP[book_abbrev]

        # Next token should be chapter spec
        if i + 1 >= len(tokens):
            raise ValueError(
                f"Missing chapter spec after {book_abbrev} in line: {line}"
            )

        chapter_spec = tokens[i + 1].strip()
        chapters = parse_chapter_spec(chapter_spec)

        for ch in chapters:
            osis_refs.append(f"{osis_book}.{ch}")

        i += 2

    return month, day, osis_refs


def main():
    input_file = Path(__file__).parent.parent / "data" / "2026_daily_reading.txt"
    output_file = Path(__file__).parent.parent / "data" / "json" / "dailyReading2026.json"

    if not input_file.exists():
        print(f"Error: {input_file} not found")
        return

    daily_readings = []

    with open(input_file, "r", encoding="utf-8") as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue

            try:
                month, day, osis_refs = parse_line(line)

                # Format ID as YYYY-MM-DD
                date_id = f"2026-{month:02d}-{day:02d}"

                daily_readings.append({"id": date_id, "osisRefs": osis_refs})

            except Exception as e:
                print(f"Error parsing line {line_num}: {line}")
                print(f"  {e}")
                raise

    # Ensure output directory exists
    output_file.parent.mkdir(parents=True, exist_ok=True)

    # Write JSON
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(daily_readings, f, ensure_ascii=False, indent=2)

    print(f"✓ Generated {len(daily_readings)} daily readings")
    print(f"✓ Saved to {output_file}")


if __name__ == "__main__":
    main()
