CREATE OR REPLACE TRIGGER aggiorna_squadre
AFTER INSERT ON ARRIVO_ATLETI
FOR EACH ROW
DECLARE
        X char(10);
        Y number;
BEGIN

SELECT NomeSquadra INTO X
FROM ATLETA
WHERE CodAtleta = :NEW.CodAtleta

SELECT COUNT(*) INTO Y
FROM ARRIVO_SQUADRE
WHERE NomeSquadra = X

IF(Y <> 0)
--squadra già presente
UPDATE ARRIVO_SQUADRE
SET NumeroAtletiArrivati = NumeroAtletiArrivati+1
WHERE NomeSquadra = X
ELSE
INSERT INTO ARRIVO_SQUADRE
VALUES(X, 1)
END IF;

END;



CREATE OR REPLACE TRIGGER aggiorna_classifica
AFTER INSERT ON ARRIVO_ATLETI
FOR EACH ROW
DECLARE
        X number;
BEGIN

SELECT COUNT(*) INTO X
FROM CLASSIFICA
WHERE Tempo < :NEW.Tempo

IF(X == 0)
INSERT ON CLASSIFICA
VALUES(1, :NEW.CodAtleta, :NEW.Tempo)

ELSE
INSERT ON CLASSIFICA
VALUES(X+1, :NEW.CodAtleta, :NEW.Tempo)

END IF;

UPDATE CLASSIFICA
SET Posizione = Posizione+1
WHERE Tempo > :NEW.Tempo

END;