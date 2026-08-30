import prisma from '../prisma/cliente.js';
import { crearMedicionSchema } from '../servicios/validacion.js';
import { evaluarCumplimiento } from '../servicios/tolerancias.js';

export async function crearMedicion(req, res, next) {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'La fotografía es obligatoria (RF-05)' });
    }

    const datos = crearMedicionSchema.parse(req.body);
    const cumple = evaluarCumplimiento(datos);

    const medicion = await prisma.medicion.create({
      data: {
        visitaId: req.params.id,
        ...datos,
        fotoRuta: req.file.path,
        cumple,
      },
    });

    res.status(201).json(medicion);
  } catch (err) {
    next(err);
  }
}
