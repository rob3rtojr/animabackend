import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function escolaRoutes(app: FastifyInstance) {
  app.get('/escolas/:municipioId', async (request) => {
    const paramsSchema = z.object({
      municipioId: z.coerce.number(),
    })

    const { municipioId } = paramsSchema.parse(request.params)

    const escola = await prisma.escola.findMany({
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        municipioId,
      },
    })

    return escola
  })
}
