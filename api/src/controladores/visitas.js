import prisma from '../prisma/cliente.js';
import { crearVisitaSchema } from '../servicios/validacion.js';

export async function crearVisita(req, res, next) {
  try {
    const datos = crearVisitaSchema.parse(req.body);
    const visita = await prisma.visita.create({ data: datos });
    res.status(201).json(visita);
  } catch (err) {
    next(err);
  }
}

export async function obtenerVisita(req, res, next) {
  try {
    const visita = await prisma.visita.findUniqueOrThrow({
      where: { id: req.params.id },
      include: { mediciones: { orderBy: { creadaEn: 'asc' } } },
    });
    res.status(200).json(visita);
  } catch (err) {
    next(err);
  }
}

export async function cerrarVisita(req, res, next) {
  try {
    const visita = await prisma.visita.update({
      where: { id: req.params.id },
      data: { cerradaEn: new Date() },
    });
    res.status(200).json(visita);
  } catch (err) {
    next(err);
  }
}
