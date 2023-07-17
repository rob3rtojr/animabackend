import '@fastify/jwt'

declare module '@fastify/jwt' {
  interface FastifyJWT {
    user: {
      sub: number
      name: string
      type: string
      formularios: string[]
    } // user type is return type of `request.user` object
  }
}
