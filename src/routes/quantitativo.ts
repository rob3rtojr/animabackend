import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { atualizarNomes } from '../lib/util'

export async function quantitativo(app: FastifyInstance) {
  app.get('/quantitativo/:formularioId', async (request) => {
    const paramsSchema = z.object({
      formularioId: z.coerce.number()
    })

    const querySchema = z.object({
      estadoId: z.coerce.number().optional(),
      regionalId: z.coerce.number().optional(),
      municipioId: z.coerce.number().optional(),
      escolaId: z.coerce.number().optional(),
      turmaId: z.coerce.number().optional(),
    })    

    const { formularioId } = paramsSchema.parse(request.params)
    const { estadoId, regionalId, municipioId, escolaId, turmaId } = querySchema.parse(request.query)

    let sql: string = ""

    //consulta o tipo do formulário
    const formulario = await prisma.formulario.findUnique({
      where: {
        id: formularioId
      },
      select: {
        id:true,
        nome:true,
        tipo:true
      }
    })


    let resultado: any[]
    let resultadoAtualizado

    if (formulario?.tipo === "aluno") {
      resultado = await prisma.$queryRaw `exec SP_RelatorioAluno ${formularioId},${estadoId},${regionalId},${municipioId},${escolaId},${turmaId}`
      if (turmaId)
        resultadoAtualizado = atualizarNomes(resultado)
    }else {
      resultado = await prisma.$queryRaw `exec SP_RelatorioProfessor ${formularioId},${estadoId},${regionalId},${municipioId}`
      if (municipioId)
        resultadoAtualizado = atualizarNomes(resultado)
    }

    return resultadoAtualizado ? resultadoAtualizado : resultado
  })
}
