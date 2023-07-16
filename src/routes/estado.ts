import { FastifyInstance } from "fastify";
import { z } from 'zod';
import { prisma } from "../lib/prisma";

export async function estadoRoutes(app: FastifyInstance) {

    app.get('/estados', async ()=> {
        const estados = await prisma.estado.findMany()
        return estados
    })

    app.get('/estados/:sigla', async (request)=> {
        
        const paramsSchema = z.object({
            sigla: z.string().length(2)
        })

        const { sigla } = paramsSchema.parse(request.params)

       const estado = await prisma.estado.findUniqueOrThrow({
        where: {
            sigla
        }
       })

       return estado
        
    })  
    
    app.post('/estados', async (request)=> {

        const bodySchema = z.object({
            nome: z.string(),
            sigla: z.string(),
            //isPubluc: z.coerce.boolean().default(false)
        })        

        const {nome, sigla} = bodySchema.parse(request.body)

        const estado = prisma.estado.create({
            data: {
                nome,
                sigla
            }
        })

        return estado

    })     

    app.put('/estados/:id', async (request)=> {
        const paramsSchema = z.object({
            id: z.coerce.number()
        })

        const bodySchema = z.object({
            nome: z.string(),
            sigla: z.string(),
            //isPubluc: z.coerce.boolean().default(false)
        }) 

        const { id } = paramsSchema.parse(request.params)
        const { nome, sigla } = bodySchema.parse(request.body)

        const estado = await prisma.estado.update({
            where: {
                id
            },
            data: {
                nome,
                sigla
            }
        })

        return estado

    })     
    
    app.delete('/estados/:id', async (request)=> {

        const paramsSchema = z.object({
            id: z.coerce.number()
        })

        const { id } = paramsSchema.parse(request.params)

       await prisma.estado.delete({
        where: {
            id
        }
       })        

    })        

}