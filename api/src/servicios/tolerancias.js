const TOLERANCIA_PLOMO_GRADOS = Number(process.env.TOLERANCIA_PLOMO_GRADOS ?? 1.5);
const TOLERANCIA_AZIMUT_GRADOS = Number(process.env.TOLERANCIA_AZIMUT_GRADOS ?? 5);

/// Diferencia angular más corta entre dos azimuts (0-360°), considerando
/// el cruce por 0/360 (por ejemplo, 359° y 2° están a 3° de distancia,
/// no a 357°).
export function diferenciaAngular(a, b) {
  const diff = Math.abs(a - b) % 360;
  return diff > 180 ? 360 - diff : diff;
}

/// Regla de negocio del proyecto: un mástil "cumple" si está a plomo en
/// ambos ejes y orientado dentro de la tolerancia de azimut. Vive en el
/// servidor porque es la fuente de verdad del reporte firmado (RF-06);
/// el cliente solo la usa para retroalimentación inmediata en pantalla.
export function evaluarCumplimiento({ inclinacionX, inclinacionY, azimut, azimutObjetivo }) {
  const plomoOk =
    Math.abs(inclinacionX) <= TOLERANCIA_PLOMO_GRADOS && Math.abs(inclinacionY) <= TOLERANCIA_PLOMO_GRADOS;
  const azimutOk = diferenciaAngular(azimut, azimutObjetivo) <= TOLERANCIA_AZIMUT_GRADOS;
  return plomoOk && azimutOk;
}

export const tolerancias = { TOLERANCIA_PLOMO_GRADOS, TOLERANCIA_AZIMUT_GRADOS };
