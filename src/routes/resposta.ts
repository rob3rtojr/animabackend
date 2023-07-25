import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function resposta(app: FastifyInstance) {
  app.post('/resposta:', async (request) => {
    await request.jwtVerify()

    const bodySchema = z.object({
      perguntaId: z.coerce.number(),
      pessoaId: z.coerce.number(),
      resposta: z.string(),
      tipo: z.string(),
      acao: z.string().length(1),
    })

    const { perguntaId, pessoaId, resposta, tipo, acao } = bodySchema.parse(
      request.body,
    )

    let respostaAluno
    let respostaProfessor

    if (tipo === 'aluno') {
      if (acao === 'I') {
        respostaAluno = await prisma.respostaAluno.create({
          data: {
            alunoId: pessoaId,
            perguntaId,
            descricao: resposta,
          },
        })
      } else if (acao === 'A') {
        {
          respostaAluno = await prisma.respostaAluno.update({
            where: { perguntaId_alunoId: { perguntaId, alunoId: pessoaId } },
            data: { descricao: resposta },
          })
        }
      } else if (acao === 'D') {
        await prisma.respostaAluno.delete({
          where: { perguntaId_alunoId: { perguntaId, alunoId: pessoaId } },
        })
        respostaAluno = []
      }
    } else if (tipo === 'professor') {
      if (acao === 'I') {
        respostaProfessor = await prisma.respostaProfessor.create({
          data: {
            professorId: pessoaId,
            perguntaId,
            descricao: resposta,
          },
        })
      } else if (acao === 'A') {
        {
          respostaProfessor = await prisma.respostaProfessor.update({
            where: { perguntaId_professorId: { perguntaId, professorId: pessoaId } },
            data: { descricao: resposta },
          })
        }
      } else if (acao === 'D') {
        await prisma.respostaProfessor.delete({
          where: { perguntaId_professorId: { perguntaId, professorId: pessoaId } },
        })
        respostaProfessor = []
      }      
    }

    const resp = tipo === 'aluno' ? respostaAluno : respostaProfessor

    return resp
  })

  // app.put('/resposta', async (request) => {

  //     const bodySchema = z.object({
  //         perguntaId: z.coerce.number(),
  //         pessoaId: z.coerce.number(),
  //         resposta: z.string(),
  //         tipo: z.string()
  //     })

  //     let respostaAluno
  //     let respostaProfessor

  //     const { perguntaId, pessoaId, resposta, tipo } = bodySchema.parse(request.body)

  //     if (tipo === "aluno") {
  //         respostaAluno = await prisma.respostaAluno.update({
  //             where: { perguntaId_alunoId: { perguntaId, alunoId: pessoaId } },
  //             data: { descricao: resposta }
  //         })
  //     }
  //     else {
  //         console.log("professor")
  //     }

  //     return respostaAluno
  // })

  // app.delete('/resposta', async (request) => {

  //     const bodySchema = z.object({
  //         perguntaId: z.coerce.number(),
  //         pessoaId: z.coerce.number(),
  //         tipo: z.string()
  //     })

  //     let respostaAluno
  //     let respostaProfessor

  //     const { perguntaId, pessoaId, tipo } = bodySchema.parse(request.body)

  //     if (tipo === "aluno") {
  //         respostaAluno = await prisma.respostaAluno.delete({ where: { perguntaId_alunoId: { perguntaId, alunoId: pessoaId } } })
  //     }
  //     else {

  //     }

  //     return respostaAluno
  // })
}
