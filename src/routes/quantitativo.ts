import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { atualizarNomes } from '../lib/util'

// Tipo para os resultados da query
type QueryResult = {
  id: number
  sigla: string
  nome: string
  createdAt: string // Datas formatadas como strings no SQL
  count: number
}

// Tipo para o formato final
type FormattedResult = {
  id: number
  sigla: string
  nome: string
  total: number
  quantitativo: Array<{
    createdAt: string
    count: number
  }>
}

export async function quantitativo(app: FastifyInstance) {
  app.get('/quantitativo/:formularioId', async (request) => {
    const paramsSchema = z.object({
      formularioId: z.coerce.number(),
    })

    const querySchema = z.object({
      estadoId: z.coerce.number().optional(),
      regionalId: z.coerce.number().optional(),
      municipioId: z.coerce.number().optional(),
      escolaId: z.coerce.number().optional(),
      turmaId: z.coerce.number().optional(),
      agrupador: z.string().optional(),
    })

    const { formularioId } = paramsSchema.parse(request.params)
    const { estadoId, regionalId, municipioId, escolaId, turmaId, agrupador } =
      querySchema.parse(request.query)

    // consulta o tipo do formulário
    const formulario = await prisma.formulario.findUnique({
      where: {
        id: formularioId,
      },
      select: {
        id: true,
        nome: true,
        tipo: true,
      },
    })

    let resultado: any[]
    let resultadoAtualizado

    if (formulario?.tipo === 'aluno') {
      resultado =
        await prisma.$queryRaw`exec SP_RelatorioAluno ${formularioId},${
          estadoId === undefined ? 0 : estadoId
        },${regionalId === undefined ? 0 : regionalId},${
          municipioId === undefined ? 0 : municipioId
        },${escolaId === undefined ? 0 : escolaId},${
          turmaId === undefined ? 0 : turmaId
        },${agrupador === undefined ? 0 : agrupador}`

      if (turmaId) resultadoAtualizado = atualizarNomes(resultado)
    } else {
      resultado =
        await prisma.$queryRaw`exec SP_RelatorioProfessor ${formularioId},${estadoId},${regionalId},${municipioId},${agrupador}`
      if (municipioId) resultadoAtualizado = atualizarNomes(resultado)
    }

    // return `exec SP_RelatorioAluno ${formularioId},${estadoId===undefined ? 0 : estadoId},${regionalId === undefined ? 0 : regionalId},${municipioId === undefined ? 0 : municipioId},${escolaId === undefined ? 0 : escolaId},${turmaId === undefined ? 0 : turmaId},'${agrupador}'`
    return resultadoAtualizado || resultado
  })

  app.get('/quantitativosa/:formularioId', async (request) => {
    const paramsSchema = z.object({
      formularioId: z.coerce.number(),
    })
    const { formularioId } = paramsSchema.parse(request.params)
    const result: QueryResult[] = await prisma.$queryRaw<QueryResult[]>`
      SELECT 
        e.id, e.sigla, e.nome,
        FORMAT(a.createdAt, 'dd/MM/yyyy') AS createdAt, 
        COUNT(DISTINCT a.id) AS count
      FROM alunosa a
      INNER JOIN estado e ON a.estadoId = e.id
      INNER JOIN respostaalunosa r ON r.alunoSAId = a.id
      INNER JOIN pergunta p ON r.perguntaId = p.id
      WHERE p.formularioId = ${formularioId}
      GROUP BY e.id, e.sigla, e.nome, FORMAT(a.createdAt, 'dd/MM/yyyy')
      order by FORMAT(a.createdAt, 'dd/MM/yyyy')
    `

    const formattedResult: FormattedResult[] = result.reduce(
      (acc: FormattedResult[], entry) => {
        const { id, sigla, nome, createdAt, count } = entry

        // Procura o estado no array acumulado
        let estado = acc.find((item) => item.id === id)

        // Se o estado não existir, cria um novo
        if (!estado) {
          estado = { id, sigla, nome, total: 0, quantitativo: [] }
          acc.push(estado)
        }
        // Adiciona a data e contagem ao estado encontrado
        estado.quantitativo.push({
          createdAt, // A data já está formatada no SQL
          count,
        })

        estado.total += count

        return acc
      },
      [],
    )

    return formattedResult
  })
}
