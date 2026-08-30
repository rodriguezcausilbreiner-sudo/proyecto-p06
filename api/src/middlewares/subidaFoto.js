import multer from 'multer';
import path from 'node:path';
import { randomUUID } from 'node:crypto';

const ALMACEN_FOTOS = path.resolve('almacen/fotos');

const storage = multer.diskStorage({
  destination: ALMACEN_FOTOS,
  filename: (req, file, cb) => {
    const ext = file.mimetype === 'image/png' ? '.png' : '.jpg';
    cb(null, `${randomUUID()}${ext}`);
  },
});

export const subidaFoto = multer({
  storage,
  limits: { fileSize: 4 * 1024 * 1024 }, // 4 MB por foto (RF-06 del backend)
  fileFilter: (req, file, cb) => {
    const ok = ['image/jpeg', 'image/png'].includes(file.mimetype);
    cb(ok ? null : new Error('Formato no permitido'), ok);
  },
});
