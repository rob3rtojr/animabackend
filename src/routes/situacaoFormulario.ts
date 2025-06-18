import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function situacaoFormulario(app: FastifyInstance) {
  app.put('/situacaoFormulario:', async (request) => {
    await request.jwtVerify()

    const bodySchema = z.object({
      pessoaId: z.coerce.number(),
      formularioId: z.coerce.number(),
      tipo: z.string(),
      situacao: z.coerce.number(),
    })

    const { pessoaId, formularioId, tipo, situacao } = bodySchema.parse(
      request.body,
    )
    let form
    if (tipo === 'aluno') {
      form =
        await prisma.$queryRaw`exec SP_IniciaFormularioAluno ${pessoaId},${formularioId},${tipo},${situacao}`
      // form = await prisma.formularioAluno.update({
      //   where: {
      //     alunoId_formularioId: {
      //       alunoId: pessoaId,
      //       formularioId,
      //     },
      //   },
      //   data: {
      //     situacao,
      //   },
      // })
    } else if (tipo === 'professor') {
      form = await prisma.formularioProfessor.update({
        where: {
          professorId_formularioId: {
            professorId: pessoaId,
            formularioId,
          },
        },
        data: {
          situacao,
        },
      })
    }

    return form
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
