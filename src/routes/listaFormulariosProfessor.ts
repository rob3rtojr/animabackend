import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function listaFormulariosProfessor(app: FastifyInstance) {
  app.get('/listaFormulariosProfessor/:professorId', async (request) => {
    await request.jwtVerify()

    const paramSchema = z.object({
      professorId: z.coerce.number(),
    })

    const { professorId } = paramSchema.parse(request.params)
    const dataAtual = new Date()

    // const estadoProfessor = await prisma.professor.findUnique({
    //   where: { id: professorId },
    //   select: {
    //     municipio: {
    //       select: {
    //         estado: {
    //           select: {
    //             id: true,
    //             nome: true,
    //             sigla: true,
    //           },
    //         },
    //       },
    //     },
    //   },
    // })

    const estadoProfessor = await prisma.professor.findUnique({
      where: {
        id: professorId,
      },
      include: {
        ProfessorEscola: {
          take: 1, // traz só o primeiro vínculo
          orderBy: {
            professorId: 'asc', // define a ordem para escolher o "primeiro"
          },
          include: {
            escola: {
              include: {
                municipio: {
                  include: {
                    estado: {
                      select: {
                        id: true,
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
    })

    const formularios = await prisma.formularioProfessor.findMany({
      where: {
        professorId,
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
            estadoId:
              estadoProfessor?.ProfessorEscola[0]?.escola.municipio.estado.id,
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
