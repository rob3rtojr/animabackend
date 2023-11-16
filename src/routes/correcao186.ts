import { FastifyInstance } from 'fastify'
import { prisma } from '../lib/prisma'

type Resultado = {
  alunoId: number
  perguntaId: number
  descricao: string
}

type Correcao = {
  alunoId: number
  antigo: string
  novo: string
  command: string
}

function arrayNovo(arr: string[]) {
  const tmp = []
  for (let i = 0; i < arr.length; i++) {
    if (tmp.indexOf(arr[i]) === -1) {
      tmp.push(arr[i])
    }
  }
  return tmp
}

export async function correcao186(app: FastifyInstance) {
  const correcoes: Correcao[] = []
  let comandos: string = ''
  let validos: string = ''
  let cont: number = 0
  const nomeTabela: string = 'respostaAluno'

  app.get('/correcao186', async (request) => {
    comandos +=
      '---remove duplicados-----------------------------------------------<br>'
    const resultado: Resultado[] = await prisma.$queryRawUnsafe(`
            Select alunoId, perguntaId, descricao
            from ${nomeTabela}
            where perguntaid = 186           
            `)

    resultado.map(async (r) => {
      const array = r.descricao.split(',')
      const arrayCorrigido = arrayNovo(array)
      const isEqual = JSON.stringify(array) === JSON.stringify(arrayCorrigido)
      // let rows: number = 0

      if (!isEqual) {
        const correcao: Correcao = {
          alunoId: r.alunoId,
          antigo: array.toString(),
          novo: arrayCorrigido.toString(),
          command: `update ${nomeTabela} set descricao = '${arrayCorrigido.toString()}' where alunoId=${
            r.alunoId
          } and perguntaid=186`,
        }

        cont++

        correcoes.push(correcao)
        comandos += correcao.command + '<br>'
        if (cont % 500 === 0) {
          comandos += '--------------------------------------------------<br>'
        }
      } else {
        if (array.toString().trim() !== '') {
          validos += array.toString() + '<br>'
        }
      }
    })
    comandos +=
      '---atualiza nulos-----------------------------------------------<br>'
    const resultadoNull: Resultado[] = await prisma.$queryRawUnsafe(`
            Select alunoId, perguntaId, descricao
            from ${nomeTabela}
            where perguntaid = 186
            and descricao=''          
            `)

    resultadoNull.map(async (r) => {
      comandos += `update ${nomeTabela} set descricao = '626' where alunoId=${r.alunoId} and perguntaid=186<br>`
    })

    return comandos
  })
}
