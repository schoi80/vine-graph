// Clean up invalid birthYear and deathYear fields
// These fields contain arrays of record IDs instead of actual years
// Set them to null until proper year data is available

MATCH (p:Person)
WHERE p.birthYear IS NOT NULL AND NOT p.birthYear IS :: INTEGER
SET p.birthYear = null;

MATCH (p:Person)
WHERE p.deathYear IS NOT NULL AND NOT p.deathYear IS :: INTEGER
SET p.deathYear = null;
