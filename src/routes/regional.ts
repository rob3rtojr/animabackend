import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function regionalRoutes(app: FastifyInstance) {
  app.get('/regionais/:estadoId', async (request) => {
    const paramsSchema = z.object({
      estadoId: z.coerce.number(),
    })

    const { estadoId } = paramsSchema.parse(request.params)

    const regional = await prisma.regional.findMany({
      orderBy: [{
        nome: 'asc'
      }],      
      where: {
        estadoId,
      },
    })

    return regional
  })
}
