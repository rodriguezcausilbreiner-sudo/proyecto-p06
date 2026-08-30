import { z } from 'zod';

export const crearVisitaSchema = z.object({
  tecnico: z.string().min(1, 'El técnico es obligatorio'),
  mastil: z.string().min(1, 'El identificador del mástil es obligatorio'),
  azimutObjetivo: z.coerce.number().min(0).max(360),
});

// multipart/form-data: todos los campos llegan como texto, por eso
// z.coerce.number() en vez de z.number().
export const crearMedicionSchema = z.object({
  inclinacionX: z.coerce.number().min(-90).max(90),
  inclinacionY: z.coerce.number().min(-90).max(90),
  azimut: z.coerce.number().min(0).max(360),
  azimutObjetivo: z.coerce.number().min(0).max(360),
  latitud: z.coerce.number().min(-90).max(90),
  longitud: z.coerce.number().min(-180).max(180),
});
