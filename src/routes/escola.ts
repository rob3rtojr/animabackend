import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function escolaRoutes(app: FastifyInstance) {
  app.get('/escolas/:municipioId', async (request) => {
    const paramsSchema = z.object({
      municipioId: z.coerce.number(),
    })

    // Validação dos parâmetros da query
    const querySchema = z.object({
      tipo: z.string().optional(),
    })

    const { municipioId } = paramsSchema.parse(request.params)
    const { tipo } = querySchema.parse(request.query)

    let escola

    if (tipo === 'aluno') {
      escola = await prisma.escola.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          municipioId,
          Turma: {
            some: {},
          },
        },
        select: {
          id: true,
          nome: true,
          codigoMec: true,
          nomeRegional: true,
          municipioId: true,
        },
      })
    } else {
      escola = await prisma.escola.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          municipioId,
        },
        select: {
          id: true,
          nome: true,
          codigoMec: true,
          nomeRegional: true,
          municipioId: true,
        },
      })
    }

    return escola
  })
}
