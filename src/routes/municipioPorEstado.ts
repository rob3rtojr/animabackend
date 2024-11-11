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

    // Validação dos parâmetros da query
    const querySchema = z.object({
      tipo: z.string().optional(),
    })

    const { estadoId } = paramsSchema.parse(request.params)
    const { tipo } = querySchema.parse(request.query)

    let municipioPorEstado

    if (tipo === 'aluno') {
      console.log('filtro aluno')
      municipioPorEstado = await prisma.municipio.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          regional: {
            estado: {
              id: estadoId,
              situacao: 'A',
            },
          },
          Escola: {
            some: {
              Turma: {
                some: {},
              },
            },
          },
        },
        select: {
          id: true,
          nome: true,
        },
      })
    } else if (tipo === 'professor') {
      municipioPorEstado = await prisma.municipio.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          regional: {
            estado: {
              id: estadoId,
              situacao: 'A',
            },
          },
          Professor: {
            some: {},
          },
        },
        select: {
          id: true,
          nome: true,
        },
      })
    } else {
      console.log('sem filtro')
      municipioPorEstado = await prisma.municipio.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          regional: {
            estado: {
              id: estadoId,
              situacao: 'A',
            },
          },
        },
        select: {
          id: true,
          nome: true,
        },
      })
    }

    return municipioPorEstado
  })
}
