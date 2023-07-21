import { FastifyInstance } from 'fastify'
import { z } from 'zod'
import { prisma } from '../lib/prisma'
import { afterEach } from 'node:test'

function replaceSpecialChars(str: string | undefined)
{
    if (str===undefined)
      return ""

    str = str.replace(/[ÀÁÂÃÄÅ]/,"A");
    str = str.replace(/[àáâãäå]/,"a");
    str = str.replace(/[ÈÉÊË]/,"E");
    str = str.replace(/[Ç]/,"C");
    str = str.replace(/[ç]/,"c");

    // o resto
    return str.replace(/[^a-z0-9]/gi,''); 
}

function getPrimeiroNome(nomeCompleto: string|undefined): string {

  if (nomeCompleto===undefined)
    return ""

  // Remova possíveis espaços em excesso antes e depois do nome
  const nomeSemEspacos = nomeCompleto.trim();

  // Divida o nome completo usando espaços como separadores
  const partesDoNome = nomeSemEspacos.split(" ");

  // O primeiro nome será o primeiro elemento do array resultante
  const primeiroNome = partesDoNome[0];

  return primeiroNome;
}


export async function authRotes(app: FastifyInstance) {
  app.post('/autenticacao', async (request, reply) => {
    const bodySchema = z.object({
      id: z.coerce.number(),
      dataNascimento: z.string(),
      matricula: z.string(),
      nomeMae: z.string(),
      cpf: z.string(),
      masp: z.string(),
      matriculaProfessor: z.string(),
      userType: z.string()
    })

    const { id, dataNascimento, matricula, nomeMae, cpf, masp, matriculaProfessor, userType } = bodySchema.parse(
      request.body,
    )
    let userExists = false
    let userName = ''
    let userId = 0
    let estadoId = 0
    let siglaEstado = ''

    // AUTENTICAÇÃO DE ALUNO
    if (userType === 'aluno') {

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
        if (replaceSpecialChars(getPrimeiroNome(userAluno?.nomeMae.toUpperCase())) === replaceSpecialChars(nomeMae.toUpperCase())) {
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
      if (masp !== '') {
        if (userProfessor?.masp === masp) {
          userExists = true
        }
      }
      if (matriculaProfessor !== '') {
        if (userProfessor?.matricula === matriculaProfessor) {
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

      let formularios

      if (userType==="aluno") {

        formularios = await prisma.formularioAluno.findMany({
          where: {
            alunoId: userId          
          },
          select: {
            alunoId:true,
            situacao: true,
            formulario: {
              select: {
                id: true,
                nome: true,
                tipo:true
              }
            }
          }
        })

      }
      else {
        formularios = await prisma.formularioProfessor.findMany({
          where: {
            professorId: userId          
          },
          select: {
            professorId:true,
            situacao: true,
            formulario: {
              select: {
                id: true,
                nome: true,
                tipo: true
              }
            }
          }
        })        
      }

      const token = app.jwt.sign(
        {
          nome: userName,
          type: userType,
          formularios,
        },
        {
          sub: userId.toString(),
          expiresIn: '1d',
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
