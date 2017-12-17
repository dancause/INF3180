SET ECHO ON
/
SET SERVEROUTPUT ON
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY'
/
insert into cours values('1','test',4);
insert into GroupeCours values('1',1,111,3,'12');
insert into SessionUQAM values(111,'01/01/2017','01/06/2017');
insert into Etudiant values ('1234','allo','bonjour',12);
insert into Etudiant values ('1235','allo','bonjour', 12);
insert into Inscription values ('1234','1',1,111,'01/01/2017','01/05/2017',12);
insert into Inscription values ('1235','1',1,111,'01/01/2017','01/05/2017',null);
/

## C1

CREATE OR REPLACE TRIGGER VALID_MINIMUM_PROF_WORK 
BEFORE INSERT ON Professeur
for each row
when (new.mincours < 4 )
BEGIN 
        RAISE_APPLICATION_ERROR( -20001,'Un des professeurs ne respect pas le minimum' );
END;

insert into Professeur values ('123','alo','bonjor',2);
insert into Professeur values ('12','allo','bonr',5);


drop trigger VALID_MINIMUM_PROF_WORK;
/ 
# C2 : La date de fin de session doit être exactement supérieure de 120 jours par rapport à la date de
# début de session. Dans le cas contraire, générer une erreur, d’une façon explicite avec le paquetage
# DBMS_OUTPUT.


create or replace trigger valid_120_jour
BEFORE INSERT on SessionUQAM
FOR EACH ROW
when ((new.dateFin - new.dateDebut) <> 120)
BEGIN
DBMS_OUTPUT.PUT_LINE('erreur dans la duree de la session');
END;
/



insert into SessionUQAM values(110,'01/01/2017','01/06/2017');
/


drop trigger valid_120_jour;
/

# C3 : La date d’abandon d’un cours doit être toujours supérieure à la date de début de session et
# toujours inférieure à la date de fin de session. 
# CREATE TABLE Inscription
#  (codePermanent 	CHAR(12) 	NOT NULL,
#  sigle 		CHAR(7) 	NOT NULL,
#  noGroupe	INTEGER		NOT NULL,
#  codeSession	INTEGER		NOT NULL,
#  dateInscription DATE		NOT NULL,
#  dateAbandon	DATE,
#  note		INTEGER,


create or replace trigger valid_abandon_date
BEFORE INSERT on Inscription
FOR EACH ROW
DECLARE
 DATFIN date;
 DATDEBUT date;

BEGIN
SELECT dateDebut,dateFin into DATDEBUT,DATFIN
from SessionUQAM
where codeSession = :new.codeSession;

IF(:new.dateAbandon < DATDEBUT) OR (:new.dateAbandon >= DATFIN )
then
DBMS_OUTPUT.PUT_LINE('erreur date abandon');
END IF;
END;
/

insert into Inscription values ('1235','1',1,111,'01/01/2017','01/01/2017',null);
  
   /
drop trigger valid_abandon_date;
/

#C4 : La date d’inscription (dateInscription) doit être toujours inférieure à la date de début de
# session et à la date de fin de session.

create or replace trigger valid_inscription_date
BEFORE INSERT on Inscription
FOR EACH ROW
DECLARE
 DATFIN date;
 DATDEBUT date;

BEGIN

SELECT dateDebut,dateFin into DATDEBUT,DATFIN
from SessionUQAM
where codeSession = :new.codeSession;

IF(:new.dateInscription >= DATDEBUT) OR (:new.dateInscription >= DATFIN ) THEN
RAISE_APPLICATION_ERROR( -20001,'erreur date Inscription');
END IF;
END;
/
drop trigger valid_inscription_date;

#C5 : Dans la table Inscription, on peut mettre à jour la note mais pas les autres attributs.

create or replace trigger valid_update_attribut
BEFORE update of codePermanent, sigle, noGroupe, codeSession, dateInscription, dateAbandon on Inscription
FOR EACH ROW

BEGIN
RAISE_APPLICATION_ERROR( -20001,'erreur date mise à jour interdit');
END;
/

update Inscription set noGroupe = 0 where codePermanent like '1234';
drop trigger valid_update_attribut;
/

# C6 : Il est interdit de faire augmenter la valeur de la note de plus de 30% lors d’une mise à jour. Si
# la valeur de la note est NULL, générer le message suivant : « Absence lors de l’épreuve ».

create or replace trigger valid_valeur_note
before update of note on Inscription
for each row
begin
if (:new.note > :old.note * 1.3) then
 RAISE_APPLICATION_ERROR( -20001,'erreur changement de note de plus de 30% interdit');
end if;
 if (:old.note is null) then
  RAISE_APPLICATION_ERROR( -20001,'absence à l épreuve');
end if;
end;
/

 update Inscription set note = 100 where codePermanent='1234';
 update Inscription set note = 14 where codePermanent='1234';
 update Inscription set note = 100 where codePermanent='1235';
drop trigger valid_valeur_note;
/



