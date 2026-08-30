import 'dotenv/config';
import app from './app.js';

const PUERTO = process.env.PORT || 3000;

app.listen(PUERTO, () => {
  console.log(`API P6 · Nivel digital de obra escuchando en http://localhost:${PUERTO}`);
});
