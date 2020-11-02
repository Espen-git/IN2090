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
SELECT f.title, f.prodyear
FROM person AS p
    NATURAL JOIN filmparticipation AS fp
    NATURAL JOIN film AS f
WHERE fp.parttype = 'director' 
    AND p.firstname = 'Stanley'
    AND p.lastname = 'Kubrick';

-- c)
SELECT f.title, f.prodyear
FROM person AS p, filmparticipation AS fp, film AS f
WHERE p.personid = fp.personid
    AND fp.filmid = f.filmid
    AND fp.parttype = 'director' 
    AND p.firstname = 'Stanley'
    AND p.lastname = 'Kubrick';

-- Oppgave 3)
SELECT p.personid, CONCAT(p.firstname, ' ', p.lastname) AS full_name, f.title, f_country.country
FROM filmcharacter AS fc
    INNER JOIN filmparticipation AS fp USING(partid)
    INNER JOIN film AS f USING(filmid)
    INNER JOIN filmcountry AS f_country USING(filmid)
    INNER JOIN person AS p USING(personid)
WHERE p.firstname = 'Ingrid'
    AND fc.filmcharacter = 'Ingrid';

-- Oppgave 4)
SELECT f.filmid, f.title, COUNT(fg.genre)
FROM filmgenre AS fg 
    RIGHT JOIN film AS f USING(filmid)
WHERE f.title LIKE '%Antoine %'
GROUP BY f.filmid, f.title;

-- Oppgave 5)
SELECT f.title, fp.parttype, COUNT(*)
FROM filmparticipation fp
    INNER JOIN film f USING(filmid)
    INNER JOIN filmitem fi USING(filmid)
WHERE f.title LIKE '%Lord of the Rings%'
    AND fi.filmtype = 'C'
GROUP BY f.title, fp.parttype;

-- Oppgave 6)
SELECT f.title, f.prodyear
FROM film f
WHERE f.prodyear = 
    (
    SELECT f.prodyear
    FROM film f
    ORDER BY f.prodyear
    LIMIT 1
    );

-- Oppgave 7)
SELECT f.title, f.prodyear
FROM 
    (
    SELECT *
    FROM filmgenre fg
    WHERE fg.genre LIKE 'Film-Noir'
    ) noir
    INNER JOIN
    (
    SELECT *
    FROM filmgenre fg
    WHERE fg.genre LIKE 'Comedy'
    ) comedy
    USING(filmid)
    INNER JOIN film f USING(filmid);

-- Oppgave 8)
WITH oldest_films AS (
    SELECT f.title, f.prodyear
    FROM film f
    WHERE f.prodyear = 
        (
        SELECT f.prodyear
        FROM film f
        ORDER BY f.prodyear
        LIMIT 1
        )
),

comedy_noir AS (
    SELECT f.title, f.prodyear
    FROM 
    (
    SELECT *
    FROM filmgenre fg
    WHERE fg.genre LIKE 'Film-Noir'
    ) noir
    INNER JOIN
    (
    SELECT *
    FROM filmgenre fg
    WHERE fg.genre LIKE 'Comedy'
    ) comedy
    USING(filmid)
    INNER JOIN film f USING(filmid)
)

SELECT *
FROM oldest_films
UNION
SELECT *
FROM comedy_noir;

-- Oppgave 9)
WITH kubrick_director AS (
    SELECT f.title, f.prodyear
    FROM person AS p
        INNER JOIN filmparticipation AS fp USING (personid)
        INNER JOIN film AS f USING (filmid)
    WHERE fp.parttype = 'director' 
        AND p.firstname = 'Stanley'
        AND p.lastname = 'Kubrick'
), 

kubrick_cast AS (
    SELECT f.title, f.prodyear
    FROM person AS p
        INNER JOIN filmparticipation AS fp USING (personid)
        INNER JOIN film AS f USING (filmid)
    WHERE fp.parttype = 'cast' 
        AND p.firstname = 'Stanley'
        AND p.lastname = 'Kubrick'
)

SELECT *
FROM kubrick_director
INTERSECT
SELECT *
FROM kubrick_cast;

-- Oppgave 10)
WITH rating AS (
SELECT *
FROM series s
    INNER JOIN filmitem fi ON (s.seriesid = fi.filmid)
    INNER JOIN filmrating fr USING(filmid)
WHERE votes > 1000
ORDER BY rank DESC
)

SELECT r.maintitle
FROM rating r
WHERE rank = 
    (
        SELECT rank
        FROM rating
        LIMIT 1
    );

-- Oppgave 11)
SELECT fc.country
FROM filmcountry fc
GROUP BY fc.country
HAVING COUNT(*) = 1;

-- Oppgave 12) 
-- Denne skal funke tar bare litt tid ca. 30 sek.
WITH unique_name AS (
    SELECT fc.filmcharacter
    FROM filmcharacter fc
    GROUP BY fc.filmcharacter
    HAVING COUNT(*) = 1
),

unique_filmcharacter AS (
    SELECT *
    FROM unique_name
        INNER JOIN filmcharacter fc USING(filmcharacter)
)

SELECT CONCAT(p.firstname, ' ', p.lastname) AS full_name, COUNT(*)
FROM unique_filmcharacter fc
    INNER JOIN filmparticipation fp USING(partid)
    INNER JOIN person p USING(personid)
WHERE fp.parttype LIKE 'cast'
GROUP BY p.firstname, p.lastname
HAVING COUNT(*) > 199;

-- Oppgave 13)
WITH good_rating AS ( --Alle filmer med minst 8 i rating og over 60000 stemmer
SELECT *
FROM film f
    INNER JOIN filmrating fr USING(filmid)
WHERE votes > 60000
    AND fr.rank >= 8
),

bad_rating AS ( --Alle filmer med mindre enn 8 i rating og over 60000 stemmer
SELECT *
FROM film f
    INNER JOIN filmrating fr USING(filmid)
WHERE votes > 60000
    AND fr.rank < 8
),

director AS ( --Alle resigører
    SELECT *
    FROM person AS p
        INNER JOIN filmparticipation AS fp USING(personid)
        INNER JOIN film AS f USING(filmid)
    WHERE fp.parttype = 'director'
),

has_bad_film AS (
    SELECT d.firstname, d.lastname
    FROM bad_rating br
        INNER JOIN director d USING(filmid)
    GROUP BY d.firstname, d.lastname
),

has_good_film AS (
    SELECT d.firstname, d.lastname
    FROM good_rating gr
        INNER JOIN director d USING(filmid)
    GROUP BY d.firstname, d.lastname
)

SELECT *
FROM has_good_film hgf
EXCEPT
SELECT *
FROM has_bad_film hbf;