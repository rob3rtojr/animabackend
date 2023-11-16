--select * from professorescola
--select * from formulario
declare @formularioId int = 6
declare @estadoId int = 2

declare @colunas_pivot as nvarchar(max)
declare @comando_sql  as nvarchar(max)

IF OBJECT_ID('tempdb..#tempPergunta') IS NOT NULL DROP TABLE #tempPergunta
IF OBJECT_ID('tempdb..#tempResp') IS NOT NULL DROP TABLE #tempResp
IF OBJECT_ID('tempdb..#tempRespMultipla') IS NOT NULL DROP TABLE #tempRespMultipla


select id
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

--select top 10 * from respostaaluno

set @colunas_pivot = 
    stuff(( select
            distinct ',' + quotename(id,'[]')  
			from #tempPergunta 
			--where formularioId = @formularioId
			--order by ',' + quotename(id,'[]') 
			for xml path('')
	), 1, 1, '')
--select * from respostaAluno where alunoid = 5
set @comando_sql = '
		select * from(
			--select top 500 ra.alunoId, a.matricula, a.nome, a.dataNascimento, a.nomeMae, a.cpf, ra.descricao as resposta, p.id
			select ra.alunoId, a.matricula, a.nome, a.dataNascimento, a.nomeMae, a.cpf, e.codigoMec as inep, e.nome as escola, t.nome as turma, ra.descricao as resposta, p.id
			from respostaAluno ra 
			inner join Pergunta p on ra.perguntaId = p.id
			inner join formularioAluno fa 
				on ra.alunoId = fa.alunoId
				and fa.formularioId = p.formularioId
			inner join aluno a on ra.alunoid = a.id
			inner join turma t on a.turmaid = t.id
			inner join escola e on t.escolaid = e.id
			inner join municipio m on e.municipioid = m.id
			inner join regional r on m.regionalid = r.id
			where p.formularioId = ' + cast(@formularioId as varchar) + '
			and fa.situacao = 3
			and r.estadoId=' + cast(@estadoId as varchar) + '
and a.id in (

	select top 500 alunoId 
	from FormularioAluno fa
	inner join Aluno a on fa.alunoId = a.id
	inner join Turma t on a.turmaId = t.id
	inner join Escola e on t.escolaId = e.id
	inner join Municipio m on e.municipioId = m.id
	inner join Regional r on m.regionalId = r.id
	where fa.situacao=3
	and r.estadoId =' + cast(@estadoId as varchar) + '
	and fa.formularioId = ' + cast(@formularioId as varchar) + '

)


		) emLinha 
		pivot ( max(resposta) for id in (' + @colunas_pivot + ')) emColunas 
		order by 1'
execute(@comando_sql)
go

--select * from pergunta 
--where formularioid =6
--order by ordem

--select * from respostaAluno where alunoid = 1786
--order by perguntaid

--select * from Escutar where perguntaId=420

select * from alternativa where id in (select escutaralternativaid from Escutar where perguntaId=420)