import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma.js'

export async function municipioRoutes(app: FastifyInstance) {
  // app.get('/municipios', async ()=> {
  //     const municipios = await prisma.estado.findMany()
  //     return municipios
  // })

  app.get('/municipios/:regionalId', async (request) => {
    const paramsSchema = z.object({
      regionalId: z.coerce.number(),
    })

    const { regionalId } = paramsSchema.parse(request.params)

    const municipio = await prisma.municipio.findMany({
      where: {
        regionalId,
      },
    })

    return municipio
  })
}
