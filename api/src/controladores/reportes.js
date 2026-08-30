import prisma from '../prisma/cliente.js';
import { generarReporteVisita } from '../servicios/reportePdf.js';

export async function descargarReporte(req, res, next) {
  try {
    const visita = await prisma.visita.findUniqueOrThrow({
      where: { id: req.params.id },
      include: { mediciones: { orderBy: { creadaEn: 'asc' } } },
    });
    generarReporteVisita(visita, res);
  } catch (err) {
    next(err);
  }
}
