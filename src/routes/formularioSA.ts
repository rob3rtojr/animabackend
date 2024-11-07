import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function formularioSA(app: FastifyInstance) {
  app.get('/formularioSA/:id', async (request, res) => {
    const paramsSchema = z.object({
      id: z.coerce.number(),
    })

    const { id } = paramsSchema.parse(request.params)

    const formulario = await prisma.pergunta.findMany({
      orderBy: [
        {
          ordem: 'asc',
        },
        {
          id: 'asc',
        },
      ],
      where: {
        formularioId: id,
      },
      include: {
        alternativa: {
          select: {
            id: true,
            descricao: true,
          },
        },
        escutar: {
          select: {
            escutarPerguntaId: true,
            escutarAlternativaId: true,
          },
        },
      },
    })

    const formularioComResposta = [...formulario]

    formulario.forEach((f, index) => {
      formularioComResposta[index] = {
        ...formularioComResposta[index],
        ...{ resposta: [] },
        ...{ respostaBanco: [] },
      }
    })

    return formularioComResposta
  })
}
