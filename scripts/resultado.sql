
--select * from formularioaluno where formularioid=4 and alunoid=894988
--select * from aluno where id = 894988
--SELECT * FROM FORMULARIO
--SELECT * FROM estado
declare @formularioId int = 3
declare @estadoId int = 3

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
and a.id in (
	select alunoId 
	from FormularioAluno fa
	inner join Aluno a on fa.alunoId = a.id
	inner join Turma t on a.turmaId = t.id
	inner join Escola e on t.escolaId = e.id
	inner join Municipio m on e.municipioId = m.id
	inner join Regional r on m.regionalId = r.id
	where fa.situacao=3
	and r.estadoId = @estadoId
	and fa.formularioId = @formularioId
)

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

--delete from tempResp
--where alunoId in (
--	529126,
--	597552,
--	111071,
--	123345,
--	139306,
--	167574,
--	172390,
--	201649,
--	213586,
--	218152,
--	224243,
--	286676,
--	312553,
--	324815,
--	334929,
--	336595,
--	348506,
--	389851,
--	396019,
--	409544,
--	449159,
--	483290,
--	493460,
--	498646,
--	503003,
--	530765,
--	535266,
--	569772,
--	622763,
--	631416,
--	632284,
--	644673,
--	651693,
--	654465,
--	660582,
--	667356,
--	677264,
--	301267,97758,198474, 194026,287399, 394630, 394630, 563564, 657061
--)