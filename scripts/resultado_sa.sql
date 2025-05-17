
--select * from formularioaluno where formularioid=4 and alunoid=894988
--select * from aluno where id = 894988
--SELECT * FROM FORMULARIO
--SELECT * FROM estado

declare @formularioId int = 5
declare @estadoId int = 8

declare @colunas_pivot as nvarchar(max)
declare @comando_sql  as nvarchar(max)

IF OBJECT_ID('tempdb..#tempPergunta') IS NOT NULL DROP TABLE #tempPergunta
IF OBJECT_ID('tempdb..#tempResp') IS NOT NULL DROP TABLE #tempResp
IF OBJECT_ID('tempdb..#tempRespMultipla') IS NOT NULL DROP TABLE #tempRespMultipla

--drop table tempResp
select 
	ra.alunoSaId,
	m.nome as municipio,
	e.nome as escola,
	t.nome as turma,
	p.numero as numeroPergunta, 
	ra.perguntaId, 
	ra.descricao, 
	p.tipoPerguntaId
into #tempResp
from RespostaAlunoSa ra
inner join Pergunta p on ra.perguntaId = p.id
inner join AlunoSa a on ra.alunosaId = a.id
left join MunicipioSA m on a.municipioId = m.id
left join EscolaSA e on a.escolaId = e.id
left join TurmaSA t on a.turmaId = t.id
where a.estadoId = @estadoId
and p.formularioId = @formularioId

alter table #tempResp add resposta varchar(100)
--alter table tempResp alter column resposta varchar(100)
--ATUALIZA AS RESPOSTAS DE UNICA ESCOLHA
update t 
set t.resposta = a.numero
from #tempResp t inner join Alternativa a on a.id = cast(t.descricao as int)
where t.tipoPerguntaId =1

--ATUALIZA AS RESPOSTAS DE MULTIPLA ESCOLHA
--select * from #tempRespMultipla
SELECT R.alunoSaId, R.perguntaId, STRING_AGG(A.numero, '|') AS numeros_alternativas
into #tempRespMultipla
FROM #tempResp R
CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
JOIN Alternativa A ON SplitDesc.value = CAST(A.id AS NVARCHAR(MAX))
where r.tipoPerguntaId = 2
GROUP BY R.alunoSaId, R.perguntaId

update r
set r.resposta = ra.numeros_alternativas
from #tempResp R 
inner join #tempRespMultipla ra on ra.perguntaId = r.perguntaId
and ra.alunosaId = r.alunosaId
-------------
update r
set r.resposta = r.descricao
from #tempResp R 
where r.tipoPerguntaId in (3,5)

-----|CORREÇÕES
--select * from pergunta
--delete from tempResp 
--where AlunoId in (select alunoid from tempResp where perguntaId = 186 and descricao = '626')
--and perguntaId in (187,189,190,191,192,193)

--delete from tempResp 
--where AlunoId in (select alunoid from tempResp where perguntaId = 418 and descricao = '1422')
--and perguntaId in (419,420)

--delete from tempResp 
--where AlunoId in (select alunoid from tempResp where perguntaId = 418 and descricao = '1423')
--and perguntaId in (419,420)

--return
-----------COL?GIO EST. ENS. M?DIO PRESID. FERNANDO HENRIQUE
--SELECT * FROM ESCOLA WHERE LEFT(CODIGOMEC,2)='15' AND NOME LIKE '%SEBASTI%'
--BEGIN TRAN
--UPDATE ESCOLA SET NOME ='COLEGIO EST. ENS. MEDIO PRESID. FERNANDO HENRIQUE' WHERE ID = 8162
--UPDATE ESCOLA SET NOME ='COLEGIO ESTADUAL PROFESSORA ISABEL AMAZONAS' WHERE ID = 8280
--UPDATE ESCOLA SET NOME ='EMEF MARCI SEBASTIAO NUNES (ANEXO I)' WHERE ID = 8114

--COMMIT
--declare @formularioId int = 4
--declare @estadoId int = 3

--declare @colunas_pivot as nvarchar(max)
--declare @comando_sql  as nvarchar(max)
-----
select numero
into #tempPergunta
from pergunta
where formularioId = @formularioId
and tipoPerguntaId <> 4
order by ordem


set @colunas_pivot = 
    stuff(( select
            distinct ',' + quotename(numero,'[]')  
			from #tempPergunta 
			--where formularioId = @formularioId
			--order by ',' + quotename(id,'[]') 
			for xml path('')
	), 1, 1, '')

-----------

set @comando_sql = '
		select * 
		from(

			select 
			ra.alunosaId, 
			ra.municipio,
			ra.escola,
			ra.turma,
			ra.resposta, 
			ra.numeroPergunta
			from #tempResp ra
			inner join Pergunta p on ra.perguntaId = p.id
			where formularioId = ' + cast(@formularioId as varchar) + '

		) emLinha 
		pivot ( max(resposta) for numeroPergunta in (' + @colunas_pivot + ')) emColunas 
		order by 1'
execute(@comando_sql)
go
------------------------------------------
--drop table tempResp
--drop table #tempRespA

--select * from ALUNOSA WHERE ESTADOID = 8