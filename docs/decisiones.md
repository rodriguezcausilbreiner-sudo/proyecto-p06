# Decisiones técnicas · P6 Nivel digital de obra

> Plantilla de partida. Completen los `[POR COMPLETAR]` con datos reales de
> su prueba de campo antes de la entrega (semana 5).

## 1. Peso del filtro complementario (0.98)

`FiltroComplementario(peso: 0.98)` da un 98 % de confianza al giroscopio en
cada actualización y solo un 2 % al acelerómetro. Se eligió así porque el
giroscopio es preciso a corto plazo (sin el temblor del acelerómetro ante
el movimiento de la mano), y el 2% restante corrige lentamente la deriva
acumulada del giroscopio usando la referencia de largo plazo del
acelerómetro (el vector de gravedad no deriva con el tiempo).

`[POR COMPLETAR]`: ¿qué peso probaron y con qué resultado? Un peso más bajo
(por ejemplo 0.90) hace la lectura más estable pero más lenta en reaccionar;
uno más alto (0.99) reacciona más rápido pero tiembla más.

## 2. Tolerancia de plomo (±1.5°) y de azimut (±5°)

Definidas en el enunciado del proyecto y aplicadas en el servidor
(`api/src/servicios/tolerancias.js`), nunca solo en el cliente: el cliente
solo replica la regla para dar retroalimentación inmediata en pantalla
(`Medicion.cumpleEnPantalla`), pero el reporte PDF firmado usa siempre el
cálculo del backend.

`[POR COMPLETAR]`: en la prueba de campo, ¿la tolerancia de 1.5° resultó
alcanzable con el trípode/soporte disponible, o fue necesario ajustar el
procedimiento de sujeción del equipo?

## 3. Resolución de inclinación (0.1°)

Definida en el enunciado (RF-01). El redondeo se aplica en
`ServicioOrientacion._emitir()` justo antes de emitir la lectura, para que
el filtro interno siga operando con precisión completa (double) y solo se
trunque el valor que ve la persona usuaria.

## 4. Limitación declarada del azimut (magnetómetro con equipo inclinado)

**El cálculo de azimut (`atan2(my, mx)`) solo es válido con el equipo
aproximadamente plano.** Al inclinar el celular, la proyección del campo
magnético terrestre sobre el plano XY cambia y el azimut reportado se
desvía del real, incluso si la orientación horizontal del equipo no
cambió.

La extensión natural (ver guía, sección de extensiones de P6) es compensar
la inclinación con una matriz de rotación usando los tres ejes del
magnetómetro y los ángulos del acelerómetro antes de calcular el azimut.
Esta versión **no implementa esa compensación**: se instruye a quien opera
la app a nivelar el equipo antes de leer el azimut.

`[POR COMPLETAR]`: si el equipo implementó la compensación como extensión,
documentar aquí la fórmula usada y el error observado con/sin compensación.

## 5. Qué se probó en un equipo de gama baja

`[POR COMPLETAR]`: equipo usado, comportamiento del magnetómetro (algunos
sensores baratos tienen mucho ruido y requieren el gesto de "figura en 8"
para recalibrarse), y cómo se manejó en la UI.
