import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function turmaRoutes(app: FastifyInstance) {
  app.get('/turmas/:escolaId', async (request) => {
    const paramsSchema = z.object({
      escolaId: z.coerce.number(),
    })

    const { escolaId } = paramsSchema.parse(request.params)

    const turma = await prisma.turma.findMany({
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        escolaId,
      },
    })

    return turma
  })

  app.get('/turmassa/:escolaSaId', async (request) => {
    const paramsSchema = z.object({
      escolaSaId: z.coerce.number(),
    })

    const { escolaSaId } = paramsSchema.parse(request.params)

    const turma = await prisma.turmaSA.findMany({
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        escolaSaId,
      },
    })

    return turma
  })

  app.get('/total-turmassa/:estadoId', async (request) => {
    const paramsSchema = z.object({
      estadoId: z.coerce.number(),
    })

    const { estadoId } = paramsSchema.parse(request.params)

    const totalTurmas = await prisma.turmaSA.count({
      where: {
        escolaSA: {
          municipioSA: {
            estadoId, // Filtro pelo estado
          },
        },
      },
    })

    return totalTurmas
  })
}
