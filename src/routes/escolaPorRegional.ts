import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function escolaPorRegionalRoutes(app: FastifyInstance) {
  app.get('/escolas-por-regional/:regionalId', async (request) => {
    const paramsSchema = z.object({
      regionalId: z.coerce.number(),
    })

    const { regionalId } = paramsSchema.parse(request.params)

    const escola = await prisma.escola.findMany({
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        municipio: {
          regionalId,
        },
      },
      select: {
        id: true,
        nome: true,
        codigoMec: true,
        municipio: true,
      },
    })

    return escola
  })
}
