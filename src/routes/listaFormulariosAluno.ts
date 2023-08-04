import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function listaFormulariosAluno(app: FastifyInstance) {
  app.get('/listaFormulariosAluno/:alunoId', async (request) => {
    await request.jwtVerify()

    const paramSchema = z.object({
      alunoId: z.coerce.number(),
    })

    const { alunoId } = paramSchema.parse(
      request.params,
    )
  

      const formularios = await prisma.formularioAluno.findMany({
        where: {
          alunoId          
        },
        select: {

          situacao: true,
          formulario: {
            select: {
              id: true,
              nome: true,
              tipo:true,
              duracao:true
            }
          }
        }
      })

    return formularios
  })
}