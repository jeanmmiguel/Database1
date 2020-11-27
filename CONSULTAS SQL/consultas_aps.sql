
1) Listar os cpf  dos alunos fixos que  fizeram inscrição  em mais de um curso;

SELECT F.CPF_FIXO
  FROM FIXOS F
  WHERE (SELECT COUNT(*) 
         FROM INSCRICAO I
         WHERE I.CPF_ALUNO_FIXO = F.CPF_FIXO) > 1;
         

2) Liste o nome distinto  dos professores substitutos que ganham mais que todos os  professores contratados
   
   select  distinct P.nome_professor
   from PROFESSOR P, SUBSTITUTO S
   where P.cpf_professor = S.CPF_PROFESSOR_SUBSTITUTO and S.salario_diaria > all
   
   (select C.salario_mensal
   from CONTRATADO C, PROFESSOR P1
   where C.CPF_PROFESSOR_CONTRATADO = P1.cpf_professor)
   
3)Mostre  os cpf dos professores para os quais a lista de matriculados das turmas  que
eles dão aulas  é menor do que três

select cpf_professor
from PROFESSOR
where cpf_professor in
(select cpf_professor
from TURMAS
where CODIGO_TURMA in (
select id_curso
from TURMAS 
group by id_curso
having count(cpf_professor) < 3))

4)Encontre os nomes dos alunos que fazem curso de inglês ou utiliza o livro APRENDIENDO ESPAÑOL 1;
select A.nome_aluno
from ALUNOS A, INSCRICAO I, CURSOS C
where I.cpf_aluno_fixo = A.cpf_aluno and C.nome_curso = 'INGLÊS'
union
select A1.nome_aluno
from ALUNOS A1, INSCRICAO I1, CURSOS C1
where I1.cpf_aluno_fixo = A1.cpf_aluno and C1.livro_curso = 'APRENDIENDO ESPAÑOL 1'

5)Encontre os alunos que moram na cidade de Londrina e estão matriculados no curso de INGLÊS

select A.nome_aluno
from ALUNOS A, ENDERECOS E
where A.cpf_aluno = E.cpf_aluno and E.cidade = 'LONDRINA' in ( select A1.cpf_aluno
									 from ALUNOS A1,INSCRICAO I, CURSOS C
									where C.id_curso = I.id_curso and C.nome_curso = 'INGLÊS')

6) encontre o nome dos professores que não  dão aula avulsa na sala numero 13
select P.nome_professor
from PROFESSOR P
where cpf_professor not in (select P1.cpf_professor
							from PROFESSOR P1, AULA_AVULSA AV
                            where P1.cpf_professor = AV.cpf_professor and AV.numero_sala = '13')
                            
7)Encontre os alunos fixos cujo o valor da mensalidade seja maior do que qualquer aluno que faz aula avulsa na sala 15
select F.cpf_fixo
from FIXOS F
where F.valor_fixo_mensal > any (select preco
								 from AULA_AVULSA AV
                                 where AV.numero_sala = '15')
                                 
8)Encontre o nome e o telefone do professor contratado que tem o maior salário

select C.cpf_professor_contratado, C.carga_horaria_mensal
from CONTRATADO C
where   (select MAX(C1.salario_mensal)
		from CONTRATADO C1) 
        
9)Para cada curso de espanhol encontre a quantidade de alunos matriculados
select C.id_curso, count(*) as contaMatriculados
from INSCRICAO I, CURSOS C
where I.id_curso = C.id_curso and C.nome_curso = 'ESPANHOL'
group by id_curso
                     
10)Mostre a quantidade de alunos matriculados  para cada nome de  curso
select C.nome_curso, count(*) as totalAlunosMatriculados
from CURSOS C, INSCRICAO I
where C.id_curso = I.id_curso 
group by C.nome_curso


11)Para cada professor que ministra aula na sala numero 32 mostre seu nome e o total de turmas que ele da aula

SELECT P.nome_professor, count(T.codigo_turma)
FROM PROFESSOR P, TURMAS T
WHERE P.cpf_professor = T.cpf_professor AND
NOT EXISTS( SELECT *
FROM TURMAS T1
WHERE P.cpf_professor = T1.cpf_professor AND
T1.numero_sala <> '32')
GROUP BY P.nome_professor

12) Mostre os alunos que estão matriculados no número máximo de cursos
(select nome_aluno
from ALUNOS
where cpf_aluno in (
select I.id_curso
from INSCRICAO I
group by I.cpf_aluno_fixo
having count(I.id_curso) = 11))

13) Sabendo que somente os alunos fixos precisam fazer inscrição nessa escola,mostre os nomes dos alunos que não fizeram inscrição, ou seja os alunos que não se inscreveram nos cursos tradicionais de (inglês, espanhol,frances)
(select A.nome_aluno
from ALUNOS A)
except
(select distinct A.nome_aluno
from ALUNOS A, INSCRICAO I
where A.cpf_aluno = I.CPF_ALUNO_FIXO)

14) Mostre a quantidade de professores alocados  para cada horario de turma
select T.horario_turma, count(*) as totalAlocados
from TURMAS  T, PROFESSOR P
where T.cpf_professor  =  P.cpf_professor
group by T.horario_turma

15) Mostre para cada aluno matriculado a sua data de inicio do curso (inicio semestre),e a data do fim do curso (final semestre)
select A.nome_aluno, I.data_inicio_semestre as dataInicio, I.data_final_semestre 
from ALUNOS A, INSCRICAO I
where A.cpf_aluno  =  I.cpf_aluno_fixo 
group by A.nome_aluno

16) Para cada aluno esporádico que faz uma aula avulsa, mostre o nome do tipo de aula que ele faz ex (conversação, listening)
select A.nome_aluno, P.material_extra
from ALUNOS A, ESPORADICO_FAZ_AULA_AVULSA E, TIPO P,AULA_AVULSA_TEM_TIPO AV, AULA_AVULSA AA,ESPORADICO ES
where ES.cpf_esporadico = E.cpf and P.id = AV.id_tipo = P.id and AA.id = E.id and ES.cpf_esporadico = A.cpf_aluno
group by A.nome_aluno



