import { FastifyInstance } from "fastify";
import { z } from 'zod';
import { prisma } from "../lib/prisma";

export async function turmaRoutes(app: FastifyInstance) {

    app.get('/turmas/:escolaId', async (request)=> {
        
        const paramsSchema = z.object({
            escolaId: z.coerce.number()
        })

        const { escolaId } = paramsSchema.parse(request.params)

       const turma = await prisma.turma.findMany({
        where: {
            escolaId
        }
       })

       return turma
        
    })      

}