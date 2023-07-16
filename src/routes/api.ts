import { FastifyInstance } from "fastify";


export async function apiRoutes(app: FastifyInstance) {

    app.get('/api', async ()=> {
        return {"result":"success"}
    })
}