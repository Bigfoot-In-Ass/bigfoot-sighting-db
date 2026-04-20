--1. Which season produces the most Bigfoot sightings, and does the event classification (Class A/B/C) vary by season?
--This reveals whether sightings cluster around certain times of year and whether more credible direct sightings (Class A) happen in different seasons than indirect evidence (Class B).

SELECT
    e.Season,
    ev.Event_Type,
    COUNT(*) AS sighting_count
FROM sightings.event ev
JOIN sightings.environment e ON ev.Environment_ID = e.Environment_ID
GROUP BY e.Season, ev.Event_Type
ORDER BY e.Season, sighting_count DESC;

--2. Which sources publish the most reports about sightings?
-- This will show which media sources are publishing bigfoot sightings the most

SELECT
    s.name,
    COUNT(*) AS total_reports
FROM sightings.report r
         JOIN sightings.source s
              ON r.source_id = s.source_id
GROUP BY s.name
ORDER BY total_reports DESC;
