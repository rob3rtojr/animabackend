import { z } from 'zod';
import { prisma } from '../lib/prisma.js';
export async function regionalRoutes(app) {
    app.get('/regionais/:estadoId', async (request) => {
        const paramsSchema = z.object({
            estadoId: z.coerce.number(),
        });
        const { estadoId } = paramsSchema.parse(request.params);
        const regional = await prisma.regional.findMany({
            where: {
                estadoId,
            },
        });
        return regional;
    });
}
//# sourceMappingURL=regional.js.map