import { z } from 'zod';
import { prisma } from '../lib/prisma.js';
export async function professorRoutes(app) {
    app.get('/professores/:municipioId', async (request) => {
        const paramsSchema = z.object({
            municipioId: z.coerce.number(),
        });
        const { municipioId } = paramsSchema.parse(request.params);
        const professor = await prisma.professor.findMany({
            where: {
                municipioId,
            },
        });
        return professor;
    });
}
//# sourceMappingURL=professor.js.map