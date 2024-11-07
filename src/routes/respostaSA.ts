/* eslint-disable prettier/prettier */
import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function respostaSA(app: FastifyInstance) {
  app.post('/respostaSA', async (request, res) => {
    const bodySchema = z.object({
      estadoId: z.coerce.number(),
      resposta: z.string(),
      tipo: z.string(),
    })

    const { estadoId, resposta, tipo } = bodySchema.parse(request.body)

    try {
      const resultado: any[] =
        await prisma.$queryRaw`exec SP_GravaRespostaSA @estadoId=${estadoId}, @json=${resposta}, @tipo=${tipo}`
console.log(`exec SP_GravaRespostaSA @estadoId=${estadoId}, @json=${resposta}, @tipo=${tipo}`)
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
