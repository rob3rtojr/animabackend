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

export async function correcaoNaoNulo(app: FastifyInstance) {
  const correcoes: Correcao[] = []
  let comandos: string = ''
  let validos: string = ''
  let cont: number = 0

  app.get('/correcao186', async (request) => {
    const resultado: Resultado[] = await prisma.$queryRaw`
            Select alunoId, perguntaId, descricao
            from testeRespostaAlunoBKP_20230816
            where perguntaid = 186
            and descricao='626'
            `

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
          command: `delete from testeRespostaAlunoBKP_20230816 where alunoId=${r.alunoId} and perguntaid in (187,189,190,191,192,193)`,
        }

        cont++

        correcoes.push(correcao)
        comandos += cont.toString() + ' - ' + correcao.command + '<br>'
        if (cont % 500 === 0) {
          comandos += '--------------------------------------------------<br>'
        }
      } else {
        if (array.toString().trim() !== '') {
          validos += array.toString() + '<br>'
        }
      }
    })

    return comandos
  })
}
