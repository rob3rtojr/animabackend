import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function deletaResposta(app: FastifyInstance) {
  app.post('/deletaResposta', async (request, res) => {
    const bodySchema = z.object({
      listaIdPergunta: z.string(),
      pessoaId: z.coerce.number(),
      tipo: z.string(),
    })

    const { listaIdPergunta, pessoaId, tipo } = bodySchema.parse(request.body)

    try {
      const resultado: any[] =
        await prisma.$queryRaw`exec SP_DeletaResposta @listaIdPergunta=${listaIdPergunta}, @pessoaId=${pessoaId}, @tipo=${tipo}`
      const { Success, Message } = resultado[0] || {
        Success: 0,
        Message: 'Erro desconhecido',
      }

      if (Success) {
        return res.status(200).send(Message)
      } else {
        return res.status(500).send(Message)
      }
    } catch (e) {
      console.log('ocorreu um erro!', e)
      return res.status(500).send('Erro ao processar a requisição')
    }
  })
}
