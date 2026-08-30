import { Router } from 'express';
import { crearVisita, obtenerVisita, cerrarVisita } from '../controladores/visitas.js';
import { crearMedicion } from '../controladores/mediciones.js';
import { descargarReporte } from '../controladores/reportes.js';
import { subidaFoto } from '../middlewares/subidaFoto.js';

const router = Router();

router.post('/visitas', crearVisita);
router.get('/visitas/:id', obtenerVisita);
router.patch('/visitas/:id/cerrar', cerrarVisita);
router.post('/visitas/:id/mediciones', subidaFoto.single('foto'), crearMedicion);
router.get('/visitas/:id/reporte', descargarReporte);

export default router;
