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
