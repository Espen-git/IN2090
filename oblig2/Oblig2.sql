--Oblig2 Espen Lønes

--Oppgave 2)
--a)
SELECT *
FROM timelistelinje
WHERE timelistenr = 3;

--b)
SELECT COUNT(*) AS "Antall timelister"
FROM timeliste;

--c)
SELECT COUNT(*) AS "Antall timelister som ikke er utbetalt"
FROM timeliste
WHERE NOT status = 'utbetalt';

--d)
SELECT COUNT(*) AS "Antall", COUNT(pause) AS "Antall med pause"
FROM timelistelinje;

--e)
SELECT *
FROM timelistelinje
WHERE pause IS NULL;

--Oppgave 3)
--a) Runner av til en desimal
SELECT CAST(SUM(varighet::decimal / 60) AS DECIMAL(9,1)) AS "Timer ikke betalt for"
FROM timeliste
NATURAL JOIN varighet
WHERE NOT status = 'utbetalt';

--b)
SELECT DISTINCT tl.timelistenr, tl.beskrivelse
FROM timeliste tl
INNER JOIN timelistelinje tll ON (tl.timelistenr = tll.timelistenr)
WHERE tll.beskrivelse LIKE '%Test%'
   OR tll.beskrivelse LIKE '%test%';

--c) Runner av til nemeste hele krone
SELECT ROUND(SUM((varighet::decimal / 60) * 200)) || ' kr' AS "Utbetalt"
FROM timeliste 
NATURAL JOIN varighet
WHERE status = 'utbetalt';

--Oppgave 4)
/*
a)
Første spørring:
Timelistenr og beskrivlse må være lik siden tabellene har disse to
kolonnene til felles. Teller da antal linjer der de to tabellene har
samme timelistenr og beskrivlese.

Andre spørring:
Kunn timelistenr som er likt mellom de to tabelene.
Alle timelistelinjer har en tilhørende timeliste.
Så i praksis teller denne antall timelistelinjer.

b)
Her deler timelise og varighet kunn en kolonne, nemlig timelitenr.
Så NATURAL JOIN sammenlikner kunn over verdiane i denne kolonnen.
Dette gjør også INNER JOIN spørringen siden her ber vi om det eksplisitt.
Så for begge blir den tabellen som telles linjer av den samme.
*/