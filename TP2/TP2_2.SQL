SET ECHO ON
/
SET SERVEROUTPUT ON
/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY'

# • La procédure prend en entrée un codeProfesseur. L’affichage est effectué avec le paquetage DBMS_OUTPUT() selon le format de l’exemple ci-bas.
# • Levez une exception qui affiche ‘Professeur inexistant’ si le code du professeur n’existe pas dans la table concernée.
# • L’exécution de la procédure devrait afficher les éléments suivants : code professeur, nom et prénom du professeur, sigle du cours, code session, no groupe, date de début de session, date de fin de session.
# • Faites un test avec un nom professeur quelconque.
# • Exemple :
# SQL> EXECUTE TacheEnseignement('BEJU0')


insert into Professeur values('xyz12','test','yoman',4);23	
insert into cours values('abcXXXX','test cours',4);insert into cours values('cdeXXXX','test cours',4);
insert into cours values('efgXXXX','test cours',4);
insert into GroupeCours values ('abcXXXX',123,111,20,'xyz12');
insert into GroupeCours values ('cdeXXXX',456,111,20,'xyz12');
insert into GroupeCours values ('efgXXXX',789,111,20,'xyz12');
/

CREATE OR REPALCE PROCEDURE TacheEnseignement( CodeProf Professeur.codeProfesseur%TYPE ) IS

DECLARE
CodeProf Professeur.codeProfesseur%TYPE;
leNom Professeur.nom%TYPE;
lePrenom professeur.Prenom%TYPE;
lesigle GroupeCours.sigle%TYPE;
lecodeSession GroupeCours.codeSession%TYPE;
legroupe GroupeCours.noGroupe%TYPE;
ledateDebut SessionUQAM.dateDebut%TYPE;

trouver boolean := false;


CURSOR lignesProfesseur(UnCodeProf Professeur.codeProfesseur%TYPE) IS
             select professeur.nom, professeur.Prenom,GroupeCours.sigle,GroupeCours.codeSession,GroupeCours.noGroupe, SessionUQAM.dateDebut
             from GroupeCours inner join Professeur on GroupeCours.codeProfesseur = professeur.codeProfesseur
                                 inner join SessionUQAM on SessionUQAM.codeSession = GroupeCours.codeSession
             WHERE GroupeCours.codeProfesseur = UnCodeProf;
BEGIN

 OPEN lignesProfesseur(CodeProf);

 LOOP
    FETCH lignesProfesseur INTO leNom, lePrenom, lesigle, lecodeSession, legroupe, ledateDebut;
    EXIT WHEN lignesProfesseur%NOTFOUND;
                DBMS_OUTPUT.PUT('Code professeur :'|| CodeProf);
                DBMS_OUTPUT.PUT('Nom :'|| leNom);
                DBMS_OUTPUT.PUT('Prénom :'|| lePrenom);
                DBMS_OUTPUT.PUT('Sigle cours :'|| lesigle);
                DBMS_OUTPUT.PUT('Code session :'|| lecodeSession);
                DBMS_OUTPUT.PUT('No groupe :'|| legroupe);
                DBMS_OUTPUT.PUT('Date début session :'|| ledateDebut);
                trouver := true;
 END LOOP;
 CLOSE lignesProfesseur;

if not trouver then
  DBMS_OUTPUT.PUT('code professeur inexistant');
end if;
END TacheEnseignement;
 /


EXECUTE TacheEnseignement('xyz12');
/
EXECUTE TacheEnseignement('xxx12');
/

insert into cours values('1','test',4);
insert into GroupeCours values('1',1,111,20,'xyz12');
insert into Etudiant values('abc123','test1','test2',827);
insert into Etudiant values('abc124','test1','test2',827);
insert into Etudiant values('abc125','test1','test2',827);
insert into Etudiant values('abc126','test1','test2',827);
insert into Etudiant values('abc127','test1','test2',827);
insert into Etudiant values('abc128','test1','test2',827);
insert into Etudiant values('abc129','test1','test2',827);
insert into Etudiant values('abc1210','test1','test2',827);
insert into Inscription values ('abc123','1',1,111,'01/01/2017','01/05/2017',99);
insert into Inscription values ('abc124','1',1,111,'01/01/2017','01/05/2017',95);
insert into Inscription values ('abc125','1',1,111,'01/01/2017','01/05/2017',12);    
insert into Inscription values ('abc126','1',1,111,'01/01/2017','01/05/2017',12);    
insert into Inscription values ('abc127','1',1,111,'01/01/2017','01/05/2017',12);
insert into Inscription values ('abc128','1',1,111,'01/01/2017','01/05/2017',12);
insert into Inscription values ('abc129','1',1,111,'01/01/2017','01/05/2017',12);
insert into Inscription values ('abc1210','1',1,111,'01/01/2017','01/05/2017',12);
/


CREATE OR REPLACE FUNCTION EXCELLENTETUDIANTS( code Inscription.codePermanent%TYPE, session Inscription.codeSession%TYPE) 
return boolean;
IS
note Inscription.note%TYPE;
trouver boolean := false;

CURSOR trouverExcellent (loSession, locode) is
    select note 
    from Inscription 
    where codesession = loSession and codePermanent = locode; 

BEGIN 
	open trouverExcellent(code, session);
		LOOP
				FETCH trouverExcellent into note;
				EXIT WHEN trouverExcellent%NOTFOUND;
				if note > 95 then
					note := true;
				end if;
		END LOOP;
	CLOSE trouverExcellent;

	RETURN trouver; 
END EXCELLENTETUDIANTS;
/




