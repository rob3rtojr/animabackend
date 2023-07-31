import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { atualizarNomes} from '../lib/util'


export async function alunoRoutes(app: FastifyInstance) {
  app.get('/alunos/:turmaId', async (request) => {
    const paramsSchema = z.object({
      turmaId: z.coerce.number(),
    })

    const { turmaId } = paramsSchema.parse(request.params)

    const aluno = await prisma.aluno.findMany({
      orderBy: [{
        nome: 'asc'
      }],
      where: {
        turmaId,
      },
      select: {
        id: true,
        nome: true
      }
    })

    const alunosAtualizados = atualizarNomes(aluno);

    return alunosAtualizados
  })
}
