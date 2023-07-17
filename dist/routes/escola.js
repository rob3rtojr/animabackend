import { z } from 'zod';
import { prisma } from '../lib/prisma.js';
export async function escolaRoutes(app) {
    app.get('/escolas/:municipioId', async (request) => {
        const paramsSchema = z.object({
            municipioId: z.coerce.number(),
        });
        const { municipioId } = paramsSchema.parse(request.params);
        const escola = await prisma.escola.findMany({
            where: {
                municipioId,
            },
        });
        return escola;
    });
}
//# sourceMappingURL=escola.js.map