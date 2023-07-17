import fastify from 'fastify'
import cors from '@fastify/cors'
import jwt from '@fastify/jwt'

import { estadoRoutes } from './routes/estado.js'
import { regionalRoutes } from './routes/regional.js'
import { municipioRoutes } from './routes/municipio.js'
import { escolaRoutes } from './routes/escola.js'
import { turmaRoutes } from './routes/turma.js'
import { alunoRoutes } from './routes/aluno.js'
import { authRotes } from './routes/auth.js'
import { formulario } from './routes/formulario.js'
import { professorRoutes } from './routes/professor.js'
import { resposta } from './routes/resposta.js'
import { apiRoutes } from './routes/api.js'

const app = fastify()

app.register(cors, {
   //origin: true,
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

const port = process.env.PORT || 3333;


app
  .listen({
    port: Number(port),
  })
  .then(() => {
    console.log(`Server running on http://localhost:${port} 👍`)
  })
