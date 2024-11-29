import { FastifyInstance } from 'fastify'
import { z } from 'zod'
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
    form.forEach((f) => {
      result.push({ id: f.id, nome: f.nome + ' - ' + f.tipo, tipo: f.tipo })
    })

    return result
  })

  app.get('/tipoFormularios/:id', async (request) => {
    const paramsSchema = z.object({
      id: z.coerce.number(),
    })

    const { id } = paramsSchema.parse(request.params)

    const form = await prisma.formulario.findUnique({
      where: {
        id,
      },
    })

    return form
  })

  app.get('/tipoFormulariosAutenticados', async (request) => {
    const form = await prisma.formulario.findMany({
      select: {
        id: true,
        nome: true,
        tipo: true,
      },
      where: {
        permiteSemAutenticacao: '0',
      },
    })

    const result: any[] = []
    form.forEach((f) => {
      result.push({ id: f.id, nome: f.nome + ' - ' + f.tipo, tipo: f.tipo })
    })

    return result
  })

  app.get('/tipoFormulariosNaoAutenticados', async (request) => {
    const form = await prisma.formulario.findMany({
      select: {
        id: true,
        nome: true,
        tipo: true,
      },
      where: {
        permiteSemAutenticacao: '1',
      },
    })

    const result: any[] = []
    form.forEach((f) => {
      result.push({ id: f.id, nome: f.nome + ' - ' + f.tipo, tipo: f.tipo })
    })

    return result
  })
}
