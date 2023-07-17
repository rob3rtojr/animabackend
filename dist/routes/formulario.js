import { z } from 'zod';
import { prisma } from '../lib/prisma.js';
export async function formulario(app) {
    app.get('/formulario/:id', async (request) => {
        await request.jwtVerify();
        const paramsSchema = z.object({
            id: z.coerce.number(),
        });
        const { id } = paramsSchema.parse(request.params);
        const formulario = await prisma.pergunta.findMany({
            orderBy: [
                {
                    ordem: 'asc',
                },
            ],
            where: {
                formularioId: id,
            },
            include: {
                alternativa: {
                    select: {
                        id: true,
                        descricao: true,
                    },
                },
                escutar: {
                    select: {
                        escutarPerguntaId: true,
                        escutarAlternativaId: true,
                    },
                },
            },
        });
        const resposta = await prisma.respostaAluno.findMany({
            where: {
                alunoId: parseInt(request.user.sub.toString()),
                pergunta: {
                    formularioId: id,
                },
            },
        });
        function filtrar(objetos, perguntaId) {
            return objetos.filter((objeto) => objeto.perguntaId === perguntaId);
        }
        const formularioComResposta = [...formulario];
        formulario.map((f, index) => {
            let respostaPergunta = new Array();
            const alternativa = [...formulario[index].alternativa];
            const filtroResposta = filtrar(resposta, f.id);
            if (filtroResposta.length > 0) {
                filtroResposta.map((rr) => {
                    if (rr.descricao) {
                        if (f.tipoPerguntaId === 2) {
                            respostaPergunta = [...rr.descricao.split(',')];
                        }
                        else {
                            respostaPergunta.push(rr.descricao);
                        }
                    }
                });
            }
            f.alternativa.map((a, indexAlternativa) => {
                let bolResposta = false;
                if (respostaPergunta.length > 0) {
                    // let x = respostaPergunta.find((rp) => { rp === a.id.toString() })
                    bolResposta = respostaPergunta.indexOf(a.id.toString()) > -1;
                    if (f.id === 17) {
                        console.log(respostaPergunta);
                    }
                }
                formularioComResposta[index].alternativa[indexAlternativa] = {
                    ...alternativa[indexAlternativa],
                    ...{ isChecked: bolResposta },
                };
            });
            // console.log({ ...formularioComResposta[index], ...{ "resposta": respostaPergunta } })
            formularioComResposta[index] = {
                ...formularioComResposta[index],
                ...{ resposta: respostaPergunta },
                ...{ respostaBanco: respostaPergunta },
            };
        });
        return formularioComResposta;
    });
}
//# sourceMappingURL=formulario.js.map