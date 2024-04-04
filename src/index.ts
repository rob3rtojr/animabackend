import fastify from 'fastify'
import cors from '@fastify/cors'
import jwt from '@fastify/jwt'

import { estadoRoutes } from './routes/estado'
import { regionalRoutes } from './routes/regional'
import { municipioRoutes } from './routes/municipio'
import { escolaRoutes } from './routes/escola'
import { turmaRoutes } from './routes/turma'
import { alunoRoutes } from './routes/aluno'
import { authRotes } from './routes/auth'
import { formulario } from './routes/formulario'
import { professorRoutes } from './routes/professor'
import { apiRoutes } from './routes/api'
import { municipioPorEstadoRoutes } from './routes/municipioPorEstado'

import { listaFormulariosAluno } from './routes/listaFormulariosAluno'
import { listaFormulariosProfessor } from './routes/listaFormulariosProfessor'
import { situacaoFormulario } from './routes/situacaoFormulario'
import { quantitativo } from './routes/quantitativo'
import { tipoFormulario } from './routes/tipoFormulario'
import { escolaPorRegionalRoutes } from './routes/escolaPorRegional'
import { correcao186 } from './routes/correcao186'
import { respostav2 } from './routes/respostav2'
import { respostav2DeleteMany } from './routes/respostav2DeleteMany'

const app = fastify()

app.register(cors, {
  origin: true,
  // EM PRODUCAO, ALTERAR PARA:
  // origin: ['https://animabackend.azurewebsites.net/','http://localhost:3000'],
})

app.register(jwt, {
  secret: 'UIUWPOEIRUNWPOIERIijkjgçiwrutnbçlerutvnweiru @!',
})

app.register(apiRoutes)
app.register(authRotes)
app.register(estadoRoutes)
app.register(regionalRoutes)
app.register(municipioRoutes)
app.register(municipioPorEstadoRoutes)
app.register(professorRoutes)
app.register(escolaRoutes)
app.register(turmaRoutes)
app.register(alunoRoutes)
app.register(formulario)
app.register(situacaoFormulario)
app.register(listaFormulariosAluno)
app.register(listaFormulariosProfessor)
app.register(quantitativo)
app.register(tipoFormulario)
app.register(escolaPorRegionalRoutes)
app.register(correcao186)

//v2
app.register(respostav2)
app.register(respostav2DeleteMany)

const port = process.env.PORT || 3333

app
  .listen({
    port: Number(port),
    host: '0.0.0.0',
  })
  .then(() => {
    console.log(`---> RS Server running on port:${port}`)
  })
