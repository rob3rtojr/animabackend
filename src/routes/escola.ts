/* eslint-disable prettier/prettier */
import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function escolaRoutes(app: FastifyInstance) {
  app.get('/escolas/:municipioId', async (request) => {
    const paramsSchema = z.object({
      municipioId: z.coerce.number(),
    })

    // Validação dos parâmetros da query
    const querySchema = z.object({
      tipo: z.string().optional(),
    })

    const { municipioId } = paramsSchema.parse(request.params)
    const { tipo } = querySchema.parse(request.query)

    let escola

    if (tipo === 'aluno') {
      escola = await prisma.escola.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          municipioId,
          Turma: {
            some: {},
          },
        },
        select: {
          id: true,
          nome: true,
          codigoMec: true,
          nomeRegional: true,
          municipioId: true,
        },
      })
    } else {
      escola = await prisma.escola.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          municipioId,
        },
        select: {
          id: true,
          nome: true,
          codigoMec: true,
          nomeRegional: true,
          municipioId: true,
        },
      })
    }

    return escola
  })

  app.get('/escolassa/:municipioSaId', async (request) => {
    const paramsSchema = z.object({
      municipioSaId: z.coerce.number(),
    })
    const querySchema = z.object({
      possuiTurma: z.string().optional(),
    })
    let escola
    const { municipioSaId } = paramsSchema.parse(request.params)
    const { possuiTurma } = querySchema.parse(request.query)

    if (possuiTurma === 'S') {
      escola = await prisma.escolaSA.findMany({
        where: {
          TurmaSA: {
            some: {}, // Verifica se existe ao menos uma turma associada
          },
          municipioSaId
        },
        orderBy: [
          {
            nome: 'asc',
          },
        ],        
      });

    } else {
      escola = await prisma.escolaSA.findMany({
        orderBy: [
          {
            nome: 'asc',
          },
        ],
        where: {
          municipioSaId,
        },
      })
    }
    return escola
  })
}
