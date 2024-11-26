import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

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
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        regionalId,
      },
    })

    return municipio
  })

  app.get('/municipiossa/:estadoId', async (request) => {
    const paramsSchema = z.object({
      estadoId: z.coerce.number(),
    })

    const { estadoId } = paramsSchema.parse(request.params)

    const municipio = await prisma.municipioSA.findMany({
      orderBy: [
        {
          nome: 'asc',
        },
      ],
      where: {
        estadoId,
      },
    })

    return municipio
  })
}
