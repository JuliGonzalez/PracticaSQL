/*TRIGGERS Y PROCEDURES*/
/*Realizado por Julián González Dos Reis (bk0136)*/

/*Pregunta 1*/

CREATE OR REPLACE
TRIGGER JP_PREGUNTA1 BEFORE
  INSERT ON DAPERMISOS FOR EACH ROW
  DECLARE
  reg USUARIOS%ROWTYPE;
  BEGIN
    SELECT* INTO reg FROM USUARIOS WHERE USUARIOS.ID_U=:NEW.USERDAPERMISO;
    IF(reg.TIPOUSUARIO<>'AD') THEN
      RAISE_APPLICATION_ERROR(-20005,'No es posible ya que el usuario no es administrador');
    END IF;
  END;
 
 /*Pregunta 2*/
 
 CREATE OR REPLACE TRIGGER JP_PREGUNTA2 BEFORE
  INSERT ON SOLICITAENTRADAS FOR EACH ROW
DECLARE
  finic exposiciones.finicio% TYPE;
  ffin exposiciones.ffin% TYPE;
  af exposiciones.aforo% TYPE;
  num_entr NUMBER;
BEGIN
  SELECT finicio, ffin, aforo INTO finic, ffin, af FROM exposiciones WHERE id_e= :new.id_e;
  SELECT COUNT(*) INTO num_entr FROM solicitaentradas WHERE id_e=:new.id_e AND fasiste=:new.fasiste;
  IF(:new.fasiste>finic AND :new.fasiste<ffin) THEN
      IF(num_entr= af) THEN
        RAISE_APPLICATION_ERROR (-20001,'Aforo completo');
      END IF;
  ELSE RAISE_APPLICATION_ERROR(-20002, 'No hay exposición para la fecha solicitada');
  END IF;
END;


 /*Pregunta 3*/
 
 CREATE OR REPLACE TRIGGER JP_PREGUNTA3 BEFORE
  INSERT ON SOLICITAENTRADAS FOR EACH ROW 
DECLARE 
  finic exposiciones.finicio% TYPE;
  ffin exposiciones.ffin% TYPE;
BEGIN
  SELECT finicio INTO finic FROM exposiciones WHERE :new.id_e= id_e;
  SELECT ffin INTO ffin FROM exposiciones WHERE :new.id_e= id_e;
  IF (:new.fsolicita<finic OR :new.fsolicita>ffin) THEN
    RAISE_APPLICATION_ERROR (-20000,'Imposible solicitar entrada');
  END IF ;
END;

 /*Pregunta 4*/
 CREATE OR REPLACE TRIGGER JP_PREGUNTA4 
AFTER INSERT ON COLECCIONES FOR EACH ROW
 BEGIN
  IF(:NEW.TIPO='Animales') THEN INSERT INTO animales (codigo_c) VALUES (:NEW.CODIGO_C);
  ELSIF(:NEW.TIPO='Lugares') THEN INSERT INTO lugares (codigo_c) VALUES (:NEW.CODIGO_C);
  ELSIF(:NEW.TIPO='Personales') THEN INSERT INTO personales (codigo_c) VALUES (:NEW.CODIGO_C);
  END IF;
 END;