import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function respostav2DeleteMany(app: FastifyInstance) {
  app.post('/respostav2DeleteMany:', async (request) => {
    await request.jwtVerify()

    const bodySchema = z.object({
      perguntaId: z.string(),
      pessoaId: z.coerce.number(),
      tipo: z.string(),
      //acao: z.string().length(1),
    })


    const { perguntaId, pessoaId, tipo } = bodySchema.parse(
      request.body,
    )

    const perguntas = perguntaId.split(',').map(Number);


    try {
      prisma.$transaction(async (tx) => {

        if (tipo === 'professor') {


            await tx.respostaProfessor.deleteMany({
              where: {
                professorId: pessoaId,
                perguntaId: {
                  in: perguntas
                }
              },
            })

        

        } else {

          await tx.respostaAluno.deleteMany({
            where: {
              alunoId: pessoaId,
              perguntaId: {
                in: perguntas
              }
            },
          })

        }

        return []

      })
    } catch (e) {
      console.log("ocorreu um erro!")
      return { message: "erro" }
    }


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
