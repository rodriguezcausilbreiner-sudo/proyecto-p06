import { test } from 'node:test';
import assert from 'node:assert/strict';
import { evaluarCumplimiento, diferenciaAngular } from '../src/servicios/tolerancias.js';
import { crearMedicionSchema } from '../src/servicios/validacion.js';

test('cumple cuando inclinación y azimut están dentro de tolerancia', () => {
  const ok = evaluarCumplimiento({ inclinacionX: 0.5, inclinacionY: -0.8, azimut: 91, azimutObjetivo: 90 });
  assert.equal(ok, true);
});

test('no cumple si la inclinación en X supera 1.5°', () => {
  const ok = evaluarCumplimiento({ inclinacionX: 2.1, inclinacionY: 0, azimut: 90, azimutObjetivo: 90 });
  assert.equal(ok, false);
});

test('no cumple si el azimut se desvía más de 5° del objetivo', () => {
  const ok = evaluarCumplimiento({ inclinacionX: 0, inclinacionY: 0, azimut: 100, azimutObjetivo: 90 });
  assert.equal(ok, false);
});

test('diferenciaAngular resuelve correctamente el cruce por 0/360°', () => {
  // 359° y 2° están a 3° de distancia real, no a 357°.
  assert.equal(diferenciaAngular(359, 2), 3);
  assert.equal(diferenciaAngular(2, 359), 3);
});

test('cumple correctamente cuando el azimut cruza 0/360 dentro de tolerancia', () => {
  const ok = evaluarCumplimiento({ inclinacionX: 0, inclinacionY: 0, azimut: 358, azimutObjetivo: 2 });
  assert.equal(ok, true); // distancia real = 4°, dentro de la tolerancia de 5°
});

test('crearMedicionSchema acepta valores numéricos enviados como texto (multipart)', () => {
  const datos = crearMedicionSchema.parse({
    inclinacionX: '0.5',
    inclinacionY: '-1.2',
    azimut: '90',
    azimutObjetivo: '90',
    latitud: '4.6486',
    longitud: '-74.0844',
  });
  assert.equal(typeof datos.inclinacionX, 'number');
});
