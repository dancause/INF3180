SET ECHO ON

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

-- Req1

select nomstation, capacite from station where region like 'ontario';

-- Req2

select activite.libelle, station.region from station inner join activite on station.nomstation=activite.nomstation where region like 'Colombie-Britannique';

-- Req3

select  CLIENT.NOM, CLIENT.PRENOM, SEJOUR.DATEDEBUT
from ACTIVITE 
		INNER JOIN STATION ON ACTIVITE.NOMSTATION=STATION.NOMSTATION
		INNER JOIN SEJOUR ON SEJOUR.STATION=STATION.NOMSTATION
		INNER JOIN CLIENT ON CLIENT.ID=SEJOUR.IDCLIENT
WHERE Station.region like 'quebec' and activite.libelle like 'kayak' and SEJOUR.DATEDEBUT >='01/01/2015' AND SEJOUR.DATEDEBUT <='31/12/2015';
Select nomStation from station where nomStation not in (select nomStation from activite);
select activite.libelle from activite inner join station on activite.nomstation=station.nomstation where station.capacite=(select max(capacite)from station);

-- Req4

Select nomStation from station where nomStation not in (select nomStation from activite);

-- Req5

select activite.libelle from activite inner join station on activite.nomstation=station.nomstation where station.capacite=(select max(capacite)from station);

-- Req6

select CLIENT.ID, CLIENT.nom, CLIENT.prenom, COUNT(*) AS NBSEJOUR
from client join sejour on CLIENT.id=SEJOUR.idclient
group by CLIENT.ID,CLIENT.nom, CLIENT.prenom
ORDER BY 4 DESC;

-- Req7

select STATION.REGION
from station INNER JOIN activite ON STATION.NOMSTATION=ACTIVITE.NOMSTATION
group by region
HAVING AVG(ACTIVITE.PRIX)>100;

-- Req8

select STATION.NOMSTATION 
from station inner join sejour on station.nomstation=sejour.station
where SEJOUR.NBPLACES =(SELECT MAX(NBPLACES) FROM SEJOUR);

-- Req9

select client.id, client.nom from client inner join sejour on client.id=sejour.idclient group by client.id, client.nom having count(*)>2;

-- Req10

SELECT STATION.NOMSTATION FROM STATION INNER JOIN SEJOUR ON STATION.NOMSTATION = SEJOUR.STATION GROUP BY STATION.NOMSTATION HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM SEJOUR GROUP BY SEJOUR.STATION);




