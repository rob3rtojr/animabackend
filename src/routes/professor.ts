import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { atualizarNomes } from '../lib/util'

export async function professorRoutes(app: FastifyInstance) {
  app.get('/professores/:municipioId', async (request) => {
    const paramsSchema = z.object({
      municipioId: z.coerce.number(),
    })

    const { municipioId } = paramsSchema.parse(request.params)

    const professor = await prisma.professor.findMany({
      orderBy: [{
        nome: 'asc'
      }],      
      where: {
        municipioId,
      },
      select: {
        id:true,
        nome:true
      }
    })

    const professoresAtualizados = atualizarNomes(professor);
    return professoresAtualizados
  })
}
