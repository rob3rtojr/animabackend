import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function municipioPorEstadoRoutes(app: FastifyInstance) {
  // app.get('/municipios', async ()=> {
  //     const municipios = await prisma.estado.findMany()
  //     return municipios
  // })

  app.get('/municipios-por-estado/:estadoId', async (request) => {
    const paramsSchema = z.object({
      estadoId: z.coerce.number(),
    })

    const { estadoId } = paramsSchema.parse(request.params)

    const municipioPorEstado = await prisma.municipio.findMany({
      orderBy: [{
        nome: 'asc'
      }],
      where: {
        regional: {
          estadoId
        }
      },
    })

    return municipioPorEstado
  })
}
