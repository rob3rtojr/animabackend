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
import { resposta } from './routes/resposta'
import { apiRoutes } from './routes/api'

const app = fastify()

app.register(cors, {
  // origin: true,
  // EM PRODUÇÃO, ALTERAR PARA:
  origin: ['https://animabackend.azurewebsites.net/'],
})

app.register(jwt, {
  secret: 'UIUWPOEIRUNWPOIERIijkjgçiwrutnbçlerutvnweiru @!',
})

app.register(apiRoutes)
app.register(authRotes)
app.register(estadoRoutes)
app.register(regionalRoutes)
app.register(municipioRoutes)
app.register(professorRoutes)
app.register(escolaRoutes)
app.register(turmaRoutes)
app.register(alunoRoutes)

app.register(formulario)
app.register(resposta)

app
  .listen({
    port: 8080,
  })
  .then(() => {
    console.log('Server running on http://localhost:8080 👍')
  })
