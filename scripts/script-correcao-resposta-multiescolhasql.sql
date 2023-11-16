

select count(*) from RespostaAluno 
where AlunoId in (select alunoid from respostaAluno where perguntaId = 186 and descricao = '626')
and perguntaId in (187,189,190,191,192,193)

select count(*) from RespostaAluno 
where perguntaId = 186 and descricao = '626'
-- 991 20:47


begin tran

--622	Discussões, em sala de aula, sobre projeto de vida	
--623	Discussões, em sala de aula, sobre habilidades socioemocionais	
--624	Discussões, em sala de aula, sobre  saúde mental	
--625	Debate, em sala de aula, sobre o preconceito quanto a transtornos mentais	
--626	Não participei de nenhuma atividade	

---| Marcou a 626 então deve avapar as respostas das perguntas |187,189,190,191,192,193|
delete from respostaAluno
from respostaAluno 
where AlunoId in (select alunoid from respostaAluno where perguntaId = 186 and descricao = '626')
and perguntaId in (187,189,190,191,192,193)

-------'622,626'
delete
from respostaAluno 
where AlunoId in (select alunoid from respostaAluno where perguntaId = 186 and descricao = '622,626' and alunoid in (10865,81964,222006,293067,335017,396416,401092,528523,581239,583141))
and perguntaId in (187,189,190,191,192,193)

update respostaAluno 
	set descricao = '626' 
	where alunoid in (10865,81964,222006,293067,335017,396416,401092,528523,581239,583141) 
	and descricao = '622,626'
	and perguntaId = 186

update respostaAluno 
	set descricao = '622' 
	where descricao = '622,626'
	and perguntaId = 186

------------'623'
update respostaAluno 
	set descricao = '626' 
	where alunoid in (110952,187906) 
	and descricao = '623'
	and perguntaId = 186

----'623,623
update respostaAluno 
	set descricao = '626' 
	where alunoid in (652616) 
	and descricao='623,623'
	and perguntaId = 186

------'623,626
update respostaAluno 
	set descricao = '626' 
	where alunoid in (229432,579495,626047,666604) 
	and descricao='623,626'
	and perguntaId = 186


-------'624
update respostaAluno 
	set descricao = '626' 
	where alunoid in (216775) 
	and descricao='624'
	and perguntaId = 186

------'624,626
delete from respostaAluno 
	where alunoid = 593710
	and perguntaId = 187

update respostaAluno 
	set descricao = '626' 
	where alunoid in (348977,521144,593710,597232) 
	and descricao='624,626'
	and perguntaId = 186

-----| 625,625
update respostaAluno 
	set descricao = '626' 
	where alunoid in (342907) 
	and descricao='625,625'
	and perguntaId = 186

----| 625,626
update respostaAluno 
	set descricao = '626' 
	where alunoid in (153294) 
	and descricao='625,626'
	and perguntaId = 186




select * from RespostaAluno
where perguntaId=186
and createdAt > '2023-08-15 18:19'



rollback
select * from alternativa where perguntaId = 186












--update respostaAluno set decricao = '622' where descricao = '622,622'
select alunoId, perguntaid, descricao
from respostaAluno where descricao = '622,622'

select * from alternativa where id = 622

-------------------



select * from RespostaAluno where perguntaId in (186,187,189,190,191,192,193)
and Alunoid = 422