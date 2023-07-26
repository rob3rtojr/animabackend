import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function listaFormulariosProfessor(app: FastifyInstance) {
  app.get('/listaFormulariosProfessor/:professorId', async (request) => {
    await request.jwtVerify()

    const paramSchema = z.object({
      professorId: z.coerce.number(),
    })

    const { professorId } = paramSchema.parse(
      request.params,
    )
  

      const formularios = await prisma.formularioProfessor.findMany({
        where: {
          professorId          
        },
        select: {

          situacao: true,
          formulario: {
            
            select: {
              id: true,
              nome: true,
              tipo:true,
            }
          }
        }
      })

    return formularios
  })
}