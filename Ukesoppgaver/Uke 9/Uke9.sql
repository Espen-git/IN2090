--1)
SELECT filmtype, COUNT(*)
FROM filmitem
GROUP BY filmtype;

--2)
WITH numberofepisodes AS (
    SELECT s.seriesid, COUNT(*) AS nr_of_episodes
    FROM episode AS e
    INNER JOIN series AS s ON (e.seriesid = s.seriesid)
    GROUP BY s.seriesid
)
SELECT s.maintitle, s.firstprodyear, n.nr_of_episodes
FROM series AS s
INNER JOIN numberofepisodes AS n ON (s.seriesid = n.seriesid)
ORDER BY s.firstprodyear
LIMIT 15;