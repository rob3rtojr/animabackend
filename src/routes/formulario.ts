import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function formulario(app: FastifyInstance) {
  app.get('/formulario/:id', async (request, res) => {
    await request.jwtVerify()

    const paramsSchema = z.object({
      id: z.coerce.number(),
    })

    const { id } = paramsSchema.parse(request.params)

    const pessoaId: number = parseInt(request.user.sub.toString())
    const userType: string = request.user.type
    let situacaoFormulario
    if (userType === 'aluno') {
      situacaoFormulario = await prisma.formularioAluno.findFirst({
        where: {
          alunoId: pessoaId,
          formularioId: id,
        },
      })
    } else {
      situacaoFormulario = await prisma.formularioProfessor.findFirst({
        where: {
          professorId: pessoaId,
          formularioId: id,
        },
      })
    }

    console.log(situacaoFormulario)

    if (situacaoFormulario?.situacao === 3) {
      return res.status(401).send([])
    }

    const formulario = await prisma.pergunta.findMany({
      orderBy: [
        {
          ordem: 'asc',
        },
        {
          id: 'asc',
        },
      ],
      where: {
        formularioId: id,
      },
      include: {
        alternativa: {
          select: {
            id: true,
            descricao: true,
          },
        },
        escutar: {
          select: {
            escutarPerguntaId: true,
            escutarAlternativaId: true,
          },
        },
      },
    })

    let respostaAluno: any[] = []
    let respostaProfessor: any[] = []

    if (request.user.type === 'aluno') {
      respostaAluno = await prisma.respostaAluno.findMany({
        where: {
          alunoId: parseInt(request.user.sub.toString()),
          pergunta: {
            formularioId: id,
          },
        },
      })
    }
    if (request.user.type === 'professor') {
      respostaProfessor = await prisma.respostaProfessor.findMany({
        where: {
          professorId: parseInt(request.user.sub.toString()),
          pergunta: {
            formularioId: id,
          },
        },
      })
    }

    const resposta =
      request.user.type === 'aluno'
        ? [...respostaAluno]
        : [...respostaProfessor]

    function filtrar(objetos: any[], perguntaId: number) {
      return objetos.filter((objeto) => objeto.perguntaId === perguntaId)
    }

    const formularioComResposta = [...formulario]

    formulario.forEach((f, index) => {
      let respostaPergunta: string[] = []
      const alternativa = [...f.alternativa]

      const filtroResposta = filtrar(resposta, f.id)
      if (filtroResposta.length > 0) {
        filtroResposta.forEach((rr) => {
          if (rr.descricao) {
            if (f.tipoPerguntaId === 2) {
              respostaPergunta = rr.descricao.split(',')
            } else {
              respostaPergunta.push(rr.descricao)
            }
          }
        })
      }

      f.alternativa.forEach((a, indexAlternativa) => {
        let bolResposta = false
        if (respostaPergunta.length > 0) {
          bolResposta = respostaPergunta.includes(a.id.toString())
        }
        formularioComResposta[index].alternativa[indexAlternativa] = {
          ...alternativa[indexAlternativa],
          ...{ isChecked: bolResposta },
        }
      })

      formularioComResposta[index] = {
        ...formularioComResposta[index],
        ...{ resposta: respostaPergunta },
        ...{ respostaBanco: respostaPergunta },
      }
    })

    return formularioComResposta
  })
}
