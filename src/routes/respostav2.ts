import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

// function removeDuplicado(arr: string[]) {
//   const tmp = []
//   for (let i = 0; i < arr.length; i++) {
//     if (tmp.indexOf(arr[i]) === -1) {
//       tmp.push(arr[i])
//     }
//   }
//   return tmp
// }

export async function respostav2(app: FastifyInstance) {
  app.post('/respostav2:', async (request, res) => {
    await request.jwtVerify()

    const bodySchema = z.object({
      perguntaId: z.coerce.number(),
      pessoaId: z.coerce.number(),
      resposta: z.string(),
      tipo: z.string(),
      //acao: z.string().length(1),
    })


    const { perguntaId, pessoaId, resposta, tipo } = bodySchema.parse(
      request.body,
    )

    try {
      prisma.$transaction(async (tx) => {

        let respostaAluno
        let respostaProfessor

        if (tipo === 'professor') {

          const rp = await tx.respostaProfessor.findUnique({
            where: {
              perguntaId_professorId: { perguntaId, professorId: pessoaId }
            }
          })

          if (rp) {

            await tx.respostaProfessor.delete({
              where: {
                perguntaId_professorId: { perguntaId, professorId: pessoaId },
              },
            })

          }

          if (resposta !== "") {
            respostaProfessor = await tx.respostaProfessor.create({
              data: {
                professorId: pessoaId,
                perguntaId,
                descricao: resposta,
              },
            })
          } else {
            respostaProfessor = []
          }          

        } else {

          const r = await tx.respostaAluno.findUnique({
            where: {
              perguntaId_alunoId: { perguntaId, alunoId: pessoaId }
            }
          })

          if (r) {

            await tx.respostaAluno.delete({
              where: {
                perguntaId_alunoId: { perguntaId, alunoId: pessoaId },
              },
            })

          }

          if (resposta !== "") {
            respostaAluno = await tx.respostaAluno.create({
              data: {
                alunoId: pessoaId,
                perguntaId,
                descricao: resposta,
              },
            })
          } else {
            respostaAluno = []
          }

        }

        const resp = tipo === 'aluno' ? respostaAluno : respostaProfessor

        return res.status(200)

      })
    } catch (e) {
      console.log("ocorreu um erro!")
      return res.status(500)
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
