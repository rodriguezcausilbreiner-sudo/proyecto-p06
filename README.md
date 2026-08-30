# P6 · Nivel digital de obra

Actividad No. 5 — SENA ADSO, ficha 3278641. Inclinómetro y brújula con
evidencia fotográfica anotada y reporte firmado en PDF.

## Estructura

```
proyecto-p06/
├── app/     # Flutter + Riverpod + Dio + camera + sensors_plus
├── api/     # Node.js + Express + Prisma + PostgreSQL + pdfkit
└── docs/    # decisiones.md, contrato-api.md
```

## Backend (`api/`)

```bash
cd api
cp .env.example .env
npm install
npx prisma migrate dev
npm run dev                # http://localhost:3000
```

Pruebas (sin base de datos, validan la regla de tolerancia):
```bash
npm test
```

## Frontend (`app/`)

```bash
cd app
flutter pub get
flutter run
```

Cambia la `baseUrl` en `lib/core/red/cliente_dio.dart` según tu red antes
de correr en dispositivo físico.

Pruebas sin dispositivo (filtro complementario — el núcleo matemático del
proyecto):
```bash
flutter test
```

## Requisitos funcionales cubiertos

| RF | Descripción | Dónde |
|---|---|---|
| RF-01 | Inclinación en dos ejes, resolución 0.1° | `dominio/servicios/filtro_complementario.dart` |
| RF-02 | Filtro complementario acelerómetro + giroscopio | `filtro_complementario.dart` + `datos/servicios/servicio_orientacion.dart` |
| RF-03 | Azimut y desviación respecto al objetivo | `servicio_orientacion.dart` (magnetómetro) |
| RF-04 | Overlay en vivo + valores grabados en la imagen | `widgets/overlay_orientacion.dart` + `datos/servicios/quemador_overlay.dart` |
| RF-05 | Foto + mediciones en una sola petición multipart | `POST /api/visitas/:id/mediciones` |
| RF-06 | Reporte PDF generado desde el servidor | `GET /api/visitas/:id/reporte` (`servicios/reportePdf.js`) |

## Criterios bloqueantes — checklist antes de sustentar

- [ ] La lectura de inclinación no tiembla: filtro complementario, no solo paso bajo (probado en `test/filtro_complementario_test.dart`).
- [ ] Los valores en pantalla coinciden con los grabados en la imagen y con los enviados al servidor.
- [ ] El servidor rechaza archivos que no sean imagen y limita el tamaño (`middlewares/subidaFoto.js`, verificado con Multer `fileFilter` + `limits`).
- [ ] `docs/decisiones.md` declara la limitación del rumbo cuando el equipo no está plano (ya escrita; completar los `[POR COMPLETAR]`).

## Pendiente por completar (equipo)

1. `npx prisma migrate dev` contra su base de datos real.
2. Probar en dos equipos físicos y llenar `docs/decisiones.md` con datos reales.
3. Ajustar `baseUrl` en `cliente_dio.dart`.
4. Confirmar permisos de cámara/ubicación en `android/app/src/main/AndroidManifest.xml` (CAMERA, ACCESS_FINE_LOCATION).
5. Mínimo 8 commits descriptivos repartidos en el tiempo de desarrollo.
