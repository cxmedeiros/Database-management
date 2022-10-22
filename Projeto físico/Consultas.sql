--  BIEL: Projetar a quantidade de médicos por hospital (GROUP BY, COUNT, INNER JOIN)

SELECT H.NOME_HOSPITAL, COUNT(M.NOME_MEDICO)
FROM MEDICO M INNER JOIN
	HOSPITAL H ON M.CNES_MEDICO = H.CNES_HOSPITAL
GROUP BY H.NOME_HOSPITAL

-- BIEL: Projetar a quantidade de médicos por hospital, se o hospital tem mais que 2 médicos (GROUP BY, HAVING, COUNT, INNER JOIN)

SELECT H.NOME_HOSPITAL, COUNT(M.NOME_MEDICO)
FROM MEDICO M INNER JOIN
	HOSPITAL H ON M.CNES_MEDICO = H.CNES_HOSPITAL
GROUP BY H.NOME_HOSPITAL
HAVING COUNT(*) > 2

-- MÁRIO: Projetar o nome dos pacientes que receberam alguma prescrição (SUBCONSULTA)

SELECT NOME_PACIENTE
FROM PACIENTE PA
WHERE PA.CPF_PACIENTE IN
(SELECT CPF_PAC_PRESCREVE FROM PRESCREVE)


-- CAMILA: Projetar os nomes de todos os atendentes e respectivos pacientes atendidos por eles que sejam do sexo feminimo (INNER JOIN)

SELECT P.NOME_PACIENTE, A.NOME_ATENDENTE
FROM PACIENTE P INNER JOIN ATENDENTE A
ON P.CPF_PACIENTE_ATENDENTE = A.CPF_ATENDENTE
WHERE P.SEXO = 'F'

-- MALU: Projetar o nome de todos os atendentes com idade superior a 45 anos e seus respectivos pacientes atendidos, quando houver (LEFT OUTER JOIN)

SELECT A.NOME_ATENDENTE, P.NOME_PACIENTE
FROM ATENDENTE A LEFT OUTER JOIN
	PACIENTE P ON A.CPF_ATENDENTE = P.CPF_PACIENTE_ATENDENTE
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

-- KAILANE: Projetar o nome dos médicos que atenderam mais pacientes do que a média (SUBCONSULTA DO TIPO ESCALAR)

-- KAILANE: Projetar o nome dos pacientes para os quais já foi receitado OMEPRAZOL (SEMI JOIN EXISTS)

-- CAMILA: Projetar o nome do médico que já atenderam esse mês (SEMI JOIN EXISTS)