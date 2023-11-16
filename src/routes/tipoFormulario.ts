import { FastifyInstance } from 'fastify'
import { prisma } from '../lib/prisma'

export async function tipoFormulario(app: FastifyInstance) {
  // app.get('/municipios', async ()=> {
  //     const municipios = await prisma.estado.findMany()
  //     return municipios
  // })

  app.get('/tipoFormularios', async (request) => {
    const form = await prisma.formulario.findMany({
      select: {
        id: true,
        nome: true,
        tipo: true,
      },
    })

    const result: any[] = []
    form.map((f) => {
      result.push({ id: f.id, nome: f.nome + ' - ' + f.tipo, tipo: f.tipo })
    })

    return result
  })
}
