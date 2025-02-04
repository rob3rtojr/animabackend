import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function listaFormulariosAluno(app: FastifyInstance) {
  app.get('/listaFormulariosAluno/:alunoId', async (request) => {
    await request.jwtVerify()

    const paramSchema = z.object({
      alunoId: z.coerce.number(),
    })

    const { alunoId } = paramSchema.parse(request.params)
    const dataAtual = new Date()

    const estadoAluno = await prisma.aluno.findUnique({
      where: { id: alunoId },
      select: {
        turma: {
          select: {
            escola: {
              select: {
                municipio: {
                  select: {
                    regional: {
                      select: {
                        estado: {
                          select: {
                            id: true,
                            nome: true,
                            sigla: true,
                          },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    })

    const formularios = await prisma.formularioAluno.findMany({
      where: {
        alunoId,
      },
      select: {
        situacao: true,
        formulario: {
          select: {
            id: true,
            nome: true,
            tipo: true,
            duracao: true,
          },
        },
      },
    })

    // Filtra apenas os formularios que atendem os critérios na tabela PeriodoPreenchimento
    const formulariosFiltrados = await Promise.all(
      formularios.map(async (form) => {
        const periodoExiste = await prisma.periodoPreenchimento.findFirst({
          where: {
            formularioId: form.formulario.id,
            estadoId: estadoAluno?.turma.escola.municipio.regional.estado.id,
            dataFinal: {
              gt: dataAtual, // dataFinal > data atual
            },
          },
        })

        return periodoExiste ? form : null
      }),
    )

    return formulariosFiltrados.filter(Boolean)
  })
}
