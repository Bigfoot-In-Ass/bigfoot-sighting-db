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


--3. 3.	Who has performed the least follow-up investigations? Who has
-- performed the most follow-up investigations?

WITH inv_follow_ups AS (SELECT
                            inv.investigator_id,
                            inv.investigator_name ||
                            CASE
                                WHEN inv.title IS NOT NULL THEN ', ' || inv.title
                                ELSE ''
                                END  ||
                            CASE
                                WHEN inv.organization IS NOT NULL THEN ' (' || inv.organization || ')'
                                ELSE ''
                                END AS investigator,
                            COUNT(fu.*) AS follow_up_count
                        FROM
                            sightings.investigator inv
                                JOIN
                            sightings.follow_up fu
                            ON
                                inv.investigator_id = fu.investigator_id
                        GROUP BY
                            inv.investigator_id)
SELECT
    'Investigator with the most follow-ups' AS Record,
    investigator AS Investigator,
    follow_up_count AS "Number of Follow-ups"
FROM
    inv_follow_ups
WHERE investigator_id =
      (SELECT investigator_id
       FROM inv_follow_ups
       WHERE follow_up_count = (SELECT MAX(follow_up_count) FROM inv_follow_ups)
       LIMIT 1)
UNION ALL
SELECT
    'Investigator with the least follow-ups' AS Record,
    investigator AS Investigator,
    follow_up_count AS "Number of Follow-ups"
FROM
    inv_follow_ups
WHERE investigator_id =
      (SELECT investigator_id
       FROM inv_follow_ups
       WHERE follow_up_count = (SELECT MIN(follow_up_count) FROM inv_follow_ups) LIMIT 1);

--4. Are there documented simultaneous Bigfoot sightings?
SELECT
    env.year,
    env.month,
    env.date_text,
    COUNT(*) AS sightings_count
FROM sightings.event e
         JOIN sightings.environment env
              ON env.environment_id = e.environment_id
WHERE env.year IS NOT NULL
  AND env.month IS NOT NULL
  AND env.date_text IS NOT NULL
GROUP BY env.year, env.month, env.date_text
HAVING COUNT(*) > 1
ORDER BY env.year, env.month, env.date_text;



--5. How many reports do not have follow-up investigations?
SELECT
    (SELECT COUNT(*) FROM sightings.follow_up) AS num_follow_ups,
    (SELECT COUNT(*) FROM sightings.event) AS num_events;
