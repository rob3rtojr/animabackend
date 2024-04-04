
--select * from formularioaluno where formularioid=4 and alunoid=894988
--select * from aluno where id = 894988
--SELECT * FROM FORMULARIO
declare @formularioId int = 6
declare @estadoId int = 2

declare @colunas_pivot as nvarchar(max)
declare @comando_sql  as nvarchar(max)

IF OBJECT_ID('tempdb..#tempPergunta') IS NOT NULL DROP TABLE #tempPergunta
IF OBJECT_ID('tempResp') IS NOT NULL DROP TABLE tempResp
IF OBJECT_ID('tempdb..#tempRespMultipla') IS NOT NULL DROP TABLE #tempRespMultipla

--select p.numero, r.* from RespostaAluno r
--inner join pergunta p on r.perguntaId = p.id
--where alunoId = 903776
--order by p.ordem

--drop table resposta_aluno_4_correcao_20230816
--drop table respostaAlunoBKP_20230816
--drop table respostaAlunoBKP_20230816_2346
--drop table testeRespostaAlunoBKP_20230816
--drop table tempResp
select 
	ra.alunoId,
	a.cpf,
	a.matricula,
	a.nome as aluno, 
	a.nomeMae,
	a.dataNascimento,
	t.nome as turma,
	e.codigoMec as inep,
	e.nome as escola, 
	m.nome as municipio, 
	r.nome as regional, 
	p.numero as numeroPergunta, 
	ra.perguntaId, 
	ra.descricao, 
	p.tipoPerguntaId
into tempResp
from RespostaAluno ra
inner join Pergunta p on ra.perguntaId = p.id
inner join Aluno a on ra.alunoId = a.id
inner join Turma t on a.turmaId = t.id
inner join Escola e on t.escolaId = e.id
inner join Municipio m on e.municipioId = m.id
inner join Regional r on m.regionalId = r.id
inner join FormularioAluno fa on ra.alunoId = fa.alunoId
where r.estadoId = @estadoId
and p.formularioId = @formularioId
and fa.formularioId = @formularioId
and fa.situacao = 3
--and a.id in (

--	select alunoId 
--	from FormularioAluno fa
--	inner join Aluno a on fa.alunoId = a.id
--	inner join Turma t on a.turmaId = t.id
--	inner join Escola e on t.escolaId = e.id
--	inner join Municipio m on e.municipioId = m.id
--	inner join Regional r on m.regionalId = r.id
--	where fa.situacao=3
--	and r.estadoId = @estadoId
--	and fa.formularioId = @formularioId

--)

alter table tempResp add resposta varchar(100)
--alter table tempResp alter column resposta varchar(100)
--ATUALIZA AS RESPOSTAS DE UNICA ESCOLHA
update t 
set t.resposta = a.numero
from tempResp t inner join Alternativa a on a.id = cast(t.descricao as int)
where t.tipoPerguntaId =1

--ATUALIZA AS RESPOSTAS DE MULTIPLA ESCOLHA
--select * from #tempRespMultipla
SELECT R.alunoId, R.perguntaId, STRING_AGG(A.numero, '|') AS numeros_alternativas
into #tempRespMultipla
FROM tempResp R
CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
JOIN Alternativa A ON SplitDesc.value = CAST(A.id AS NVARCHAR(MAX))
where r.tipoPerguntaId = 2
GROUP BY R.alunoId, R.perguntaId

update r
set r.resposta = ra.numeros_alternativas
from tempResp R 
inner join #tempRespMultipla ra on ra.perguntaId = r.perguntaId
and ra.alunoId = r.alunoId
-------------
update r
set r.resposta = r.descricao
from tempResp R 
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
			ra.alunoId, 
			ra.cpf,
			ra.matricula,
			ra.aluno, 
			ra.nomeMae,
			ra.dataNascimento,
			ra.turma, 
			ra.inep,
			ra.escola, 
			ra.municipio, 
			ra.regional, 

			ra.resposta, 
			ra.numeroPergunta
			from tempResp ra
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

			--select ra.alunoId, a.nome as aluno , t.nome as turna, e.nome as escola, m.nome as municipio, r.nome as regional, e.nome as estado, ra.perguntaId, ra.descricao, p.tipoPerguntaId
			----into tempResp
			--from RespostaAluno ra
			--inner join Pergunta p on ra.perguntaId = p.id
			--inner join Aluno a on ra.alunoId = a.id
			--inner join Turma t on a.turmaId = t.id
			--inner join Escola e on t.escolaId = e.id
			--inner join Municipio m on e.municipioId = m.id
			--inner join Regional r on m.regionalId = r.id
			--where r.estadoId = 2
			--and p.formularioId = 4
			--and a.id = 212

--			alter table tempResp add resposta varchar(max)

--			update t 
--			set t.resposta = a.numero
--			from tempResp t inner join Alternativa a on a.id = cast(t.descricao as int)
--			where t.tipoPerguntaId =1
--			--select * from tipopergunta
--			select * from tempResp

--			--update t 
--			--set t.resposta = a.numero
--			--from tempResp t inner join Alternativa a on a.id = cast(t.descricao as int)
--			--where t.tipoPerguntaId =2
--			----select * from tipopergunta
--			--select * from tempResp

----SELECT R.perguntaId, A.numero
----FROM tempResp R
----CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
----JOIN Alternativa A ON SplitDesc.value = CAST(A.id AS NVARCHAR(MAX))
----where r.tipoPerguntaId = 2

--SELECT R.perguntaId, STRING_AGG(A.numero, '|') AS numeros_alternativas
--into #tempRespA
--FROM tempResp R
--CROSS APPLY STRING_SPLIT(R.descricao, ',') AS SplitDesc
--JOIN Alternativa A ON SplitDesc.value = CAST(A.id AS NVARCHAR(MAX))
--where r.tipoPerguntaId = 2
--GROUP BY R.perguntaId

--select * from #tempRespA
--select * from tempResp

--update r
--set r.resposta = ra.numeros_alternativas
----select r.resposta, ra.numeros_alternativas
--from tempResp R 
--inner join #tempRespA ra on ra.perguntaId = r.perguntaId


--select * from tempResp

----SELECT Value FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ');

----SELECT value
----FROM respostaAluno ra
----CROSS APPLY STRING_SPLIT(ra.descricao, ',') 
----where ra.perguntaid = 186
----and ra.alunoid = 212

----select * from Pergunta where tipoPerguntaId = 2
----select * from Alternativa where perguntaId = 186

----select * from TipoPergunta


----select STRING_SPLIT(descricao,',') from respostaAluno
----where perguntaid = 186
----and alunoid = 212
--------------------------------------------

----select * from formularioaluno 
----where alunoid = 212
----and formularioid = 4

----begin tran
----update formularioaluno set situacao=3
----where alunoid = 212
----and formularioid = 4
------commit
------rollback

----select * from aluno where id = 212
----select * from turma where id = 1225
----select * from escola where id=4067
----select * from municipio  where id = 745

------select * from formularioaluno where situacao=3
