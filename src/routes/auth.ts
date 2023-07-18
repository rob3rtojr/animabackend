import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'

export async function authRotes(app: FastifyInstance) {
  app.post('/autenticacao', async (request, reply) => {
    const bodySchema = z.object({
      id: z.coerce.number(),
      dataNascimento: z.string(),
      matricula: z.string(),
      nomeMae: z.string(),
      cpf: z.string(),
    })

    const { id, dataNascimento, matricula, nomeMae, cpf } = bodySchema.parse(
      request.body,
    )
    let userExists = false
    let userType = ''
    let userName = ''
    let userId = 0
    let estadoId = 0
    let siglaEstado = ''

    // AUTENTICAÇÃO DE ALUNO
    if (cpf === '') {
      userType = 'aluno'
      const userAluno = await prisma.aluno.findUnique({
        where: {
          id,
        },
        include: {
          turma: {
            include: {
              escola: {
                include: {
                  municipio: {
                    include: {
                      regional: {
                        include: {
                          estado: {
                            select: {
                              id: true,
                              sigla: true,
                            },
                          },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      })

      estadoId = userAluno
        ? userAluno.turma.escola.municipio.regional.estadoId
        : 0

      if (dataNascimento !== '') {
        if (userAluno?.dataNascimento === dataNascimento) {
          userExists = true
        }
      }
      if (matricula !== '') {
        if (userAluno?.matricula === matricula) {
          userExists = true
        }
      }
      if (nomeMae !== '') {
        if (userAluno?.nomeMae === nomeMae) {
          userExists = true
        }
      }

      if (userExists) {
        userName = userAluno ? userAluno.nome : ''
        userId = userAluno ? userAluno.id : 0
        siglaEstado = userAluno
          ? userAluno.turma.escola.municipio.regional.estado.sigla
          : ''
      }
    } else {
      userType = 'professor'

      const userProfessor = await prisma.professor.findUnique({
        where: {
          id,
        },
        include: {
          municipio: {
            include: {
              regional: {
                include: {
                  estado: {
                    select: {
                      id: true,
                      sigla: true,
                    },
                  },
                },
              },
            },
          },
        },
      })

      estadoId = userProfessor ? userProfessor.municipio.regional.estadoId : 0

      if (cpf !== '') {
        if (userProfessor?.cpf === cpf) {
          userExists = true
        }
      }

      if (userExists) {
        userName = userProfessor ? userProfessor.nome : ''
        userId = userProfessor ? userProfessor.id : 0
        siglaEstado = userProfessor
          ? userProfessor.municipio.regional.estado.sigla
          : ''
      }
    }

    if (userExists) {
      const formularios = await prisma.formulario.findMany({
        where: {
          tipo: userType,
          FormularioEstado: {
            some: {
              estadoId,
            },
          },
        },
        select: {
          id: true,
          nome: true,
        },
      })

      const token = app.jwt.sign(
        {
          nome: userName,
          type: userType,
          formularios,
        },
        {
          sub: userId.toString(),
          expiresIn: '1 days',
        },
      )
      // console.log(token)
      return {
        id: userId,
        nome: userName,
        role: userType,
        siglaEstado,
        formularios,
        accessToken: token,
      }
      // return ({userId:userId, userName:userName,  userType: userType, formularios: formularios})
    } else {
      return null
    }
  })
}
