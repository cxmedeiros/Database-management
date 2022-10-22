-- NOMES DOS MEDICAMENTOS QUE ESTÃO VENCIDOS
-- (CONSULTA NORMAL)
SELECT M.NOME_MEDICAMENTO
FROM MEDICAMENTO M
WHERE M.VALIDADE_MEDICAMENTO < TO_DATE('2022/10/22','YYYY/MM/DD')

--  BIEL: Projetar a quantidade de médicos por hospital 
--(GROUP BY, COUNT, INNER JOIN)

SELECT H.NOME_HOSPITAL, COUNT(M.NOME_MEDICO)
FROM MEDICO M INNER JOIN
	HOSPITAL H ON M.CNES_MEDICO = H.CNES_HOSPITAL
GROUP BY H.NOME_HOSPITAL

-- BIEL: Projetar a quantidade de médicos por hospital, se o hospital tem mais que 2 médicos 
--(GROUP BY, HAVING, COUNT, INNER JOIN)

SELECT H.NOME_HOSPITAL, COUNT(M.NOME_MEDICO)
FROM MEDICO M INNER JOIN
	HOSPITAL H ON M.CNES_MEDICO = H.CNES_HOSPITAL
GROUP BY H.NOME_HOSPITAL
HAVING COUNT(*) > 2

-- MÁRIO: Projetar o nome dos pacientes que receberam alguma prescrição 
--(SUBCONSULTA NORMAL)

SELECT NOME_PACIENTE
FROM PACIENTE PA
WHERE PA.CPF_PACIENTE IN
(SELECT CPF_PAC_PRESCREVE FROM PRESCREVE)


-- CAMILA: Projetar os nomes de todos os atendentes e respectivos pacientes atendidos por eles que sejam do sexo feminimo
--(INNER JOIN)

SELECT P.NOME_PACIENTE, A.NOME_ATENDENTE
FROM PACIENTE P INNER JOIN ATENDENTE A
ON P.CPF_PACIENTE_ATENDENTE = A.CPF_ATENDENTE
WHERE P.SEXO = 'F'

-- MALU: Projetar o nome de todos os atendentes com idade superior a 45 anos e seus respectivos pacientes atendidos, quando houver 
--(LEFT OUTER JOIN)

SELECT A.NOME_ATENDENTE, P.NOME_PACIENTE
FROM ATENDENTE A LEFT OUTER JOIN
	PACIENTE P ON A.CPF_ATENDENTE = P.CPF_PACIENTE_ATENDENTE
WHERE A.DT_NASC_ATENDENTE < TO_DATE('1980/12/31','YYYY/MM/DD')

-- CAMILA E MÁRIO: Projetar o nome de todos os atendentes com idade superior a 45 anos e seus respectivos pacientes atendidos, quando houver 
--(RIGHT OUTER JOIN)

SELECT A.NOME_ATENDENTE, P.NOME_PACIENTE
FROM PACIENTE P RIGHT OUTER JOIN
    ATENDENTE A ON A.CPF_ATENDENTE = P.CPF_PACIENTE_ATENDENTE
WHERE A.DT_NASC_ATENDENTE < TO_DATE('1980/12/31','YYYY/MM/DD')

-- BIEL: Projetar os nomes de todos os enfermeiros que atuam na mesma categoria de um enfermeiro com CPF específico, e é mais velho que este
-- (SUBCONSULTA DO TIPO TABELA);

SELECT NOME_ENFERMEIRO
FROM ENFERMEIRO E
WHERE E.CATEGORIA =
	(SELECT CATEGORIA
	FROM ENFERMEIRO
	WHERE CPF_ENFERMEIRO = '28859793211')
	AND E.DT_NASC_ENFERMEIRO <
	(SELECT DT_NASC_ENFERMEIRO
	FROM ENFERMEIRO
    WHERE CPF_ENFERMEIRO = '28859793211')


-- MALU: Projetar o nome de todos os médicos que já foram gerentes do hospital e suas respectivas especialidades
-- (SUBCONSULTA DO TIPO TABELA)

SELECT M.NOME_MEDICO, M.ESPECIALIDADE
FROM MEDICO M
WHERE M.CPF_MEDICO IN
	(SELECT *
	FROM GERENCIA G)

-- KAILANE: Projetar o nome dos médicos que atenderam mais pacientes do que a média 
-- (SUBCONSULTA DO TIPO ESCALAR)

SELECT M.NOME_MEDICO
FROM MEDICO M INNER JOIN 
(SELECT C.CPF_MED, COUNT(C.CPF_PAC)
    FROM CONSULTA C
    GROUP BY C.CPF_MED
    HAVING Count(*) > (SELECT AVG(QTD)
    	FROM (SELECT C.CPF_MED,COUNT(C.CPF_PAC) AS QTD
        	FROM CONSULTA C 
			GROUP  BY C.CPF_MED)))
ON M.CPF_MEDICO = CPF_MED 

-- KAILANE: Projetar o nome dos pacientes para os quais já foi receitado OMEPRAZOL (SEMI JOIN EXISTS)

-- CAMILA e MÁRIO: O ramal dos atendentes que tem pacientes agendados 
--(SEMI JOIN COM IN)

SELECT A.RAMAL 
FROM ATENDENTE A
WHERE A.CPF_ATENDENTE IN
    (SELECT P.CPF_PACIENTE_ATENDENTE
     FROM PACIENTE P
     WHERE P.CPF_PACIENTE_ATENDENTE IS NOT NULL);

-- CAMILA e MÁRIO: O ramal dos atendentes que NÃO tem pacientes agendados 
--(ANTI JOIN COM IN)

SELECT A.RAMAL
FROM ATENDENTE A
WHERE A.CPF_ATENDENTE NOT IN
    (SELECT P.CPF_PACIENTE_ATENDENTE
     FROM PACIENTE P
     WHERE P.CPF_PACIENTE_ATENDENTE IS NOT NULL);

-- CAMILA : Projetar os nomes dos médicos que trabalham na mesma instituição e tem a mesma especialidade que o médico com o cpf 27719625196
--(SUBCONSULTA DO TIPO LINHA)
--obs: acaba retornando o próprio médcico com esse CPF (não consegui ajeitar, mas não acho q esteja errado porque ta igual uma do slide de robson)

SELECT NOME_MEDICO
FROM MEDICO
WHERE (CNES_MEDICO, ESPECIALIDADE) =
    (SELECT CNES_MEDICO, ESPECIALIDADE
    FROM MEDICO
    WHERE CPF_MEDICO = '27719625196');

-- Camila: Para cada médico projetar o seu nome e o nome dos médicos mais novos que ele
-- (AUTO JUNÇÃO)

SELECT M1.NOME_MEDICO, M2.NOME_MEDICO
FROM MEDICO M1 INNER JOIN 
    MEDICO M2 ON M1.DT_NASC_MEDICO < M2.DT_NASC_MEDICO