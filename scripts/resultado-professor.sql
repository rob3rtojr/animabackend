
--select * from formulario
--select * from ESTADO
--select * from pergunta where formularioid=5 and numero=36
--select * from escutar where escutarperguntaid=325
declare @formularioId int = 2
declare @estadoId int = 1

declare @colunas_pivot as nvarchar(max)
declare @comando_sql  as nvarchar(max)

IF OBJECT_ID('tempdb..#tempPergunta') IS NOT NULL DROP TABLE #tempPergunta
IF OBJECT_ID('tempdb..#tempResp') IS NOT NULL DROP TABLE #tempResp
IF OBJECT_ID('tempdb..#tempRespMultipla') IS NOT NULL DROP TABLE #tempRespMultipla


select numero
into #tempPergunta
from pergunta
where formularioId = @formularioId
and tipoPerguntaId <> 4
order by ordem

--select id, numero, ordem
--from pergunta
--where formularioId = @formularioId
--and tipoPerguntaId <> 4
--order by ordem

set @colunas_pivot = 
    stuff(( select
            distinct ',' + quotename(numero,'[]')  
			from #tempPergunta 
			--where formularioId = @formularioId
			--order by ',' + quotename(id,'[]') 
			for xml path('')
	), 1, 1, '')


select 
	rp.professorId,
	RIGHT(REPLICATE('0', 11) + pro.cpf, 11) as cpf,
	pro.nome as professor, 
	pro.masp,
	pro.matricula,
	pro.dataNascimento,
	e.codigoMec as inep,
	e.nome as escola, 
	m.nome as municipio, 
	r.nome as regional, 
	p.numero as numeroPergunta, 
	rp.perguntaId, 
	rp.descricao, 
	p.tipoPerguntaId
into #tempResp
from RespostaProfessor rp
inner join Pergunta p on rp.perguntaId = p.id
inner join professor pro on rp.professorId = pro.id
inner join Municipio m on pro.municipioId = m.id
inner join Regional r on m.regionalId = r.id
inner join Formularioprofessor fp on rp.professorId = fp.professorId
inner join professorEscola pe on pro.id = pe.professorId
inner join Escola e on pe.escolaid = e.id
where r.estadoId = @estadoId
and p.formularioId = @formularioId
and fp.formularioId = @formularioId
and fp.situacao = 3
and pro.id in (

	select professorId 
	from Formularioprofessor fp
	inner join professor pro on fp.professorId = pro.id
	inner join Municipio m on pro.municipioId = m.id
	inner join Regional r on m.regionalId = r.id
	where fp.situacao=3
	and r.estadoId = @estadoId
	and fp.formularioId = @formularioId

)
--select * from #tempResp where numeropergunta='05'

alter table #tempResp add resposta varchar(100)
--alter table #tempResp alter column resposta varchar(100)
--ATUALIZA AS RESPOSTAS DE UNICA ESCOLHA
update t 
set t.resposta = a.numero
from #tempResp t inner join Alternativa a on a.id = cast(t.descricao as int)
where t.tipoPerguntaId =1

--ATUALIZA AS RESPOSTAS DE MULTIPLA ESCOLHA
--select * from #tempRespMultipla
SELECT R.professorId, R.perguntaId, STRING_AGG(a.numero, '|') AS numeros_alternativas
into #tempRespMultipla
FROM #tempResp R
CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
JOIN Alternativa A ON SplitDesc.value = CAST(a.id AS NVARCHAR(MAX))
where r.tipoPerguntaId = 2
GROUP BY R.professorId, R.perguntaId

update r
set r.resposta = rp.numeros_alternativas
from #tempResp R 
inner join #tempRespMultipla rp on rp.perguntaId = r.perguntaId
and rp.professorId = r.professorId
-------------
update r
set r.resposta = r.descricao
from #tempResp R 
where r.tipoPerguntaId in (3,5)



set @comando_sql = '
		select * from(

			select 
			rp.professorId, 
			rp.cpf,
			rp.professor, 
			rp.masp,
			rp.matricula,
			rp.dataNascimento,
			rp.inep,
			rp.escola, 
			rp.municipio, 
			rp.regional, 

			rp.resposta, 
			rp.numeroPergunta
			from #tempResp rp
			inner join Pergunta p on rp.perguntaId = p.id
			where formularioId = ' + cast(@formularioId as varchar) + '

		) emLinha 
		pivot ( max(resposta) for numeroPergunta in (' + @colunas_pivot + ')) emColunas 
		order by 1'
execute(@comando_sql)
go

------------------------------------------
--drop table #tempResp
--drop table #tempRespA

			--select rp.professorId, p.nome as professor , t.nome as turna, e.nome as escola, m.nome as municipio, r.nome as regional, e.nome as estado, rp.perguntaId, rp.descricao, p.tipoPerguntaId
			----into #tempResp
			--from RespostaProfessor rp
			--inner join Pergunta p on rp.perguntaId = p.id
			--inner join professor p on rp.professorId = p.id
			--inner join Turma t on p.turmaId = t.id
			--inner join Escola e on t.escolaId = e.id
			--inner join Municipio m on e.municipioId = m.id
			--inner join Regional r on m.regionalId = r.id
			--where r.estadoId = 2
			--and p.formularioId = 4
			--and p.id = 212

--			alter table #tempResp add resposta varchar(max)

--			update t 
--			set t.resposta = p.numero
--			from #tempResp t inner join Alternativa a on p.id = cast(t.descricao as int)
--			where t.tipoPerguntaId =1
--			--select * from tipopergunta
--			select * from #tempResp

--			--update t 
--			--set t.resposta = p.numero
--			--from #tempResp t inner join Alternativa a on p.id = cast(t.descricao as int)
--			--where t.tipoPerguntaId =2
--			----select * from tipopergunta
--			--select * from #tempResp

----SELECT R.perguntaId, p.numero
----FROM #tempResp R
----CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
----JOIN Alternativa A ON SplitDesc.value = CAST(p.id AS NVARCHAR(MAX))
----where r.tipoPerguntaId = 2

--SELECT R.perguntaId, STRING_AGG(p.numero, '|') AS numeros_alternativas
--into #tempRespA
--FROM #tempResp R
--CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
--JOIN Alternativa A ON SplitDesc.value = CAST(p.id AS NVARCHAR(MAX))
--where r.tipoPerguntaId = 2
--GROUP BY R.perguntaId

--select * from #tempRespA
--select * from #tempResp

--update r
--set r.resposta = rp.numeros_alternativas
----select r.resposta, rp.numeros_alternativas
--from #tempResp R 
--inner join #tempRespA rp on rp.perguntaId = r.perguntaId


--select * from #tempResp

----SELECT Value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ');

----SELECT value
----FROM RespostaProfessor rp
----CROSS APPLY STRING_SPLIT(rp.descricao, ',') 
----where rp.perguntaid = 186
----and rp.professorid = 212

----select * from Pergunta where tipoPerguntaId = 2
----select * from Alternativa where perguntaId = 186

----select * from TipoPergunta


----select STRING_SPLIT(descricao,',') from RespostaProfessor
----where perguntaid = 186
----and professorid = 212
--------------------------------------------

----select * from formularioprofessor 
----where professorid = 212
----and formularioid = 4

----begin tran
----update formularioprofessor set situacao=3
----where professorid = 212
----and formularioid = 4
------commit
------rollback

----select * from professor where id = 212
----select * from turma where id = 1225
----select * from escola where id=4067
----select * from municipio  where id = 745

------select * from formularioprofessor where situacao=3