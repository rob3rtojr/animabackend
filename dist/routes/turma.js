import { z } from 'zod';
import { prisma } from '../lib/prisma.js';
export async function turmaRoutes(app) {
    app.get('/turmas/:escolaId', async (request) => {
        const paramsSchema = z.object({
            escolaId: z.coerce.number(),
        });
        const { escolaId } = paramsSchema.parse(request.params);
        const turma = await prisma.turma.findMany({
            where: {
                escolaId,
            },
        });
        return turma;
    });
}
//# sourceMappingURL=turma.js.map