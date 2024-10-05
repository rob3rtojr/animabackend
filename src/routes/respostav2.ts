import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

// function removeDuplicado(arr: string[]) {
//   const tmp = []
//   for (let i = 0; i < arr.length; i++) {
//     if (tmp.indexOf(arr[i]) === -1) {
//       tmp.push(arr[i])
//     }
//   }
//   return tmp
// }

export async function respostav2(app: FastifyInstance) {
  app.post('/respostav2:', async (request, res) => {
    await request.jwtVerify()

    const bodySchema = z.object({
      perguntaId: z.coerce.number(),
      pessoaId: z.coerce.number(),
      resposta: z.string(),
      tipo: z.string(),
      // acao: z.string().length(1),
    })

    const { perguntaId, pessoaId, resposta, tipo } = bodySchema.parse(
      request.body,
    )

    // Simular atraso de 2 segundos
    // await new Promise(resolve => setTimeout(resolve, 3000));

    try {
      const resultado: any[] =
        await prisma.$queryRaw`exec SP_GravaResposta ${pessoaId},${perguntaId},${resposta},${tipo}`

      if (resultado[0].mensagem === 'OK') {
        return res.status(200).send(resultado)
      } else {
        return res.status(500).send(resultado)
      }
    } catch (e) {
      console.log('ocorreu um erro!')
      return res.status(500)
    }
  })
}
