/*PROCEDURES*/
/*Realizado por Julián González Dos Reis (bk0136)*/

/*Pregunta 5*/
create or replace
PROCEDURE JP_PREGUNTA5
AS
  CURSOR dbcursor
  is
    SELECT e.id_e,
      e.denominacion,
      s.fsolicita,
      COUNT(*) num_entradas
    FROM solicitaentradas s,
      exposiciones e
    WHERE s.id_e=e.id_e
    GROUP BY e.id_e,
      e.denominacion,
      s.fsolicita;
  
  solicita dbcursor%ROWTYPE;
BEGIN
  OPEN dbcursor;
  dbms_output.put_line('Resultado de la consulta');
  LOOP
    FETCH dbcursor INTO solicita;
    
    IF(dbcursor%FOUND)THEN dbms_output.put_line(to_Char(solicita.id_e)||'  '||to_Char(solicita.denominacion)||'  '||to_Char(solicita.fsolicita)||'  '||to_Char(solicita.num_entradas)||' entradas');
    END IF;
    EXIT
  WHEN dbcursor%NOTFOUND;
  END LOOP;
  CLOSE dbcursor;
END JP_PREGUNTA5;

/*Pregunta 6*/
create or replace
PROCEDURE JP_PREGUNTA6
  (
    usuario IN dapermisos.userrecibeperm%TYPE)
AS
  CURSOR cur
  is
    SELECT fecha,
      permiso,
      userdapermiso
    FROM dapermisos
    WHERE userrecibeperm= usuario
    AND permiso NOT    IN
      (SELECT permiso
      FROM dapermisos
      WHERE userrecibeperm= usuario
      AND tipo            ='Revoca'
      );
  
  reg cur%ROWTYPE;
BEGIN
  OPEN cur;
  dbms_output.put_line('Resultado de la consulta sobre usuario '||usuario);
  LOOP
    FETCH cur INTO reg;
    IF(cur%FOUND)THEN dbms_output.put_line(to_Char(reg.fecha)||'   '||to_Char(reg.permiso)||'   '||to_Char(reg.userdapermiso));
    END IF;
    EXIT WHEN cur%NOTFOUND;
  END LOOP;
  CLOSE cur;
END JP_PREGUNTA6;


/*Pregunta 7*/
create or replace
PROCEDURE JP_PREGUNTA7
  (id_userdap IN dapermisos.userdapermiso%TYPE,
    id_userrec IN dapermisos.userrecibeperm% TYPE)
AS
  CURSOR cur IS SELECT id_u,usuario,nombre,apellidos FROM usuarios WHERE validado='1';
  reg cur%ROWTYPE;
BEGIN
  UPDATE usuarios SET validado=1 WHERE id_u= id_userrec;
  INSERT
  INTO dapermisos
    (
      id_permiso,
      userdapermiso,
      userrecibeperm,
      fecha,
      tipo,
      permiso
    )
    VALUES
    (
      sq_dapermiso.nextval,
      id_userdap,
      id_userrec,
      SYSDATE,
      'Otorga',
      'Validado'
    );
  dbms_output.put_line('Usuarios validados: ');
  OPEN cur;
  LOOP
    FETCH cur INTO reg;
    IF(cur%FOUND)THEN dbms_output.put_line(to_Char(reg.id_u)||'   '||to_Char(reg.nombre)||'   '||to_Char(reg.apellidos));
    END IF;
    EXIT WHEN cur%NOTFOUND;
  END LOOP;
  CLOSE cur;
END JP_PREGUNTA7;
