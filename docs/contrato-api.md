# Contrato de API · P6 Nivel digital de obra

Base URL local: `http://localhost:3000/api`.

## POST /api/visitas

**Body** `{ "tecnico": "...", "mastil": "M-12", "azimutObjetivo": 90 }`

**Respuesta 201**: objeto `Visita` con `id`.

## GET /api/visitas/:id

Devuelve la visita con su arreglo de `mediciones`.

## PATCH /api/visitas/:id/cerrar

Marca `cerradaEn` con la hora actual. Sin body.

## POST /api/visitas/:id/mediciones

**multipart/form-data** — foto y mediciones en una sola petición (RF-05):

| Campo | Tipo | Descripción |
|---|---|---|
| `foto` | archivo (jpg/png, máx 4 MB) | Evidencia con overlay ya grabado |
| `inclinacionX` | texto numérico | Grados |
| `inclinacionY` | texto numérico | Grados |
| `azimut` | texto numérico | 0-360° |
| `azimutObjetivo` | texto numérico | 0-360° |
| `latitud` | texto numérico | |
| `longitud` | texto numérico | |

**Respuesta 201**: objeto `Medicion` con `cumple` calculado por el
servidor (tolerancia ±1.5° de plomo, ±5° de azimut).

**Respuesta 400**: formato de imagen no permitido, tamaño excedido, o
campos numéricos inválidos.

## GET /api/visitas/:id/reporte

Descarga el reporte PDF de la visita con todas sus mediciones y
fotografías incrustadas (RF-06). `Content-Type: application/pdf`.

## GET /salud

Chequeo de disponibilidad. `{ "estado": "ok" }`.
