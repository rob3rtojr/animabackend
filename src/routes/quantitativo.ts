import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { atualizarNomes } from '../lib/util'

export async function quantitativo(app: FastifyInstance) {
  app.get('/quantitativo/:formularioId', async (request) => {
    const paramsSchema = z.object({
      formularioId: z.coerce.number(),
    })

    const querySchema = z.object({
      estadoId: z.coerce.number().optional(),
      regionalId: z.coerce.number().optional(),
      municipioId: z.coerce.number().optional(),
      escolaId: z.coerce.number().optional(),
      turmaId: z.coerce.number().optional(),
      agrupador: z.string().optional(),
    })

    const { formularioId } = paramsSchema.parse(request.params)
    const { estadoId, regionalId, municipioId, escolaId, turmaId, agrupador } =
      querySchema.parse(request.query)

    // consulta o tipo do formulário
    const formulario = await prisma.formulario.findUnique({
      where: {
        id: formularioId,
      },
      select: {
        id: true,
        nome: true,
        tipo: true,
      },
    })

    let resultado: any[]
    let resultadoAtualizado

    if (formulario?.tipo === 'aluno') {
      resultado =
        await prisma.$queryRaw`exec SP_RelatorioAluno ${formularioId},${
          estadoId === undefined ? 0 : estadoId
        },${regionalId === undefined ? 0 : regionalId},${
          municipioId === undefined ? 0 : municipioId
        },${escolaId === undefined ? 0 : escolaId},${
          turmaId === undefined ? 0 : turmaId
        },${agrupador === undefined ? 0 : agrupador}`
      if (turmaId) resultadoAtualizado = atualizarNomes(resultado)
    } else {
      resultado =
        await prisma.$queryRaw`exec SP_RelatorioProfessor ${formularioId},${estadoId},${regionalId},${municipioId},${agrupador}`
      if (municipioId) resultadoAtualizado = atualizarNomes(resultado)
    }
    console.log(
      `exec SP_RelatorioProfessor ${formularioId},${
        estadoId === undefined ? 0 : estadoId
      },${regionalId === undefined ? 0 : regionalId},${
        municipioId === undefined ? 0 : municipioId
      },${agrupador === undefined ? 0 : agrupador}`,
    )
    // return `exec SP_RelatorioAluno ${formularioId},${estadoId===undefined ? 0 : estadoId},${regionalId === undefined ? 0 : regionalId},${municipioId === undefined ? 0 : municipioId},${escolaId === undefined ? 0 : escolaId},${turmaId === undefined ? 0 : turmaId},'${agrupador}'`
    return resultadoAtualizado || resultado
  })
}
