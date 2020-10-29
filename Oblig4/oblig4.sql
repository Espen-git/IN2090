-- Oppgave 1)
SELECT filmcharacter AS rollefigurnavn, COUNT(filmcharacter) AS antall_forekomster
FROM filmcharacter
GROUP BY filmcharacter
HAVING COUNT(filmcharacter) > 2000
ORDER BY antall_forekomster DESC;

-- Oppgave 2)
-- a)
SELECT f.title, f.prodyear
FROM person AS p
    INNER JOIN filmparticipation AS fp USING (personid)
    INNER JOIN film AS f USING (filmid)
WHERE fp.parttype = 'director' 
    AND p.firstname = 'Stanley'
    AND p.lastname = 'Kubrick';

-- b)
