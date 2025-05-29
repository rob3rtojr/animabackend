import { FastifyInstance } from 'fastify'

export async function filtrosAdmRoutes(app: FastifyInstance) {
  app.get('/grupos', async (request, reply) => {
    const grupos = [
      { id: 'CONTROLE', nome: 'CONTROLE' },
      { id: 'TRATAMENTO', nome: 'TRATAMENTO' },
    ]

    return reply.send(grupos)
  })

  app.get('/estratos', async (request, reply) => {
    const grupos = [
      { id: 'GRUPO 1', nome: 'GRUPO 1' },
      { id: 'GRUPO 2', nome: 'GRUPO 2' },
      { id: 'GRUPO 3', nome: 'GRUPO 3' },
    ]

    return reply.send(grupos)
  })
}
