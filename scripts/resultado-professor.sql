
--select * from formulario
--select * from ESTADO
--select * from pergunta where formularioid=5 and numero=36
--select * from escutar where escutarperguntaid=325
declare @formularioId int = 10
declare @estadoId int = 7

declare @colunas_pivot as nvarchar(max)
declare @comando_sql  as nvarchar(max)

IF OBJECT_ID('tempdb..#tempPergunta') IS NOT NULL DROP TABLE #tempPergunta
IF OBJECT_ID('tempdb..#tempResp') IS NOT NULL DROP TABLE #tempResp
IF OBJECT_ID('tempdb..#tempRespMultipla') IS NOT NULL DROP TABLE #tempRespMultipla


select identificador as numero
into #tempPergunta
from pergunta
where formularioId = @formularioId
and tipoPerguntaId <> 4
order by identificador
--select * from #tempPergunta
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
			--order by 1
			for xml path('')
	), 1, 1, '')

select 
	rp.professorId,
	RIGHT(REPLICATE('0', 11) + pro.cpf, 11) as cpf,
	pro.nome as professor, 
	pro.masp,
	pro.matricula,
	pro.dataNascimento,
	pro.email,
	pro.celular,
	pro.grupo,
	pro.estrato,
	e.codigoMec as inep,
	e.nome as escola, 
	m.nome as municipio, 
	e.nomeRegional as regional, 
	p.identificador as numeroPergunta, 
	rp.perguntaId, 
	rp.descricao, 
	p.tipoPerguntaId
into #tempResp
from RespostaProfessor rp
inner join Pergunta p on rp.perguntaId = p.id
inner join professor pro on rp.professorId = pro.id
inner join Municipio m on pro.municipioId = m.id
--inner join Regional r on m.regionalId = r.id
inner join Formularioprofessor fp on rp.professorId = fp.professorId
left join professorEscola pe on pro.id = pe.professorId
left join Escola e on pe.escolaid = e.id
where m.estadoId = @estadoId
and p.formularioId = @formularioId
and fp.formularioId = @formularioId
and fp.situacao = 3
and pro.id in (

	select professorId 
	from Formularioprofessor fp
	inner join professor pro on fp.professorId = pro.id
	inner join Municipio m on pro.municipioId = m.id
	--inner join Regional r on m.regionalId = r.id
	where fp.situacao=3
	and m.estadoId = @estadoId
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
			rp.email,
			rp.celular,
			rp.grupo, 
			rp.estrato,
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

--SELECT * FROM TEMPRESPPROFESSOR WHERE [17] IS NULL

--select *, '0'+numero as new from Pergunta where len(numero) = 1
--begin tran
--update Pergunta 
--set numero = '0'+numero
--where len(numero) = 1
----commit
--------------------------------------------
----drop table #tempResp
----drop table #tempRespA



--select * from 
--Pergunta p 
--left join #tempResp T on p.id = t.perguntaId
--where professorId = 57028

--select * from pergunta P INNER JOIN Alternativa A ON A.perguntaId = P.ID 
--where formularioId = 8 AND P.NUMERO = 7


--select * from escutar where perguntaId in (663)
--SELECT * FROM Alternativa WHERE perguntaId = 758
--SELECT * FROM PERGUNTA WHERE ID = 758