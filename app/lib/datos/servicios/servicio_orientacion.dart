import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../../dominio/servicios/filtro_complementario.dart';

class LecturaOrientacion {
  final double inclinacionX;
  final double inclinacionY;
  final double azimut;
  const LecturaOrientacion({required this.inclinacionX, required this.inclinacionY, required this.azimut});
}

/// Orquesta los tres sensores de RF-01/RF-02/RF-03. La estabilización usa
/// FiltroComplementario (lógica pura, probada aparte); esta clase solo
/// conecta los streams de sensors_plus con ese filtro.
///
/// Limitación declarada (ver docs/decisiones.md): el azimut del
/// magnetómetro solo es válido con el equipo aproximadamente plano.
class ServicioOrientacion {
  final _filtroX = FiltroComplementario();
  final _filtroY = FiltroComplementario();

  StreamSubscription<AccelerometerEvent>? _subAccel;
  StreamSubscription<GyroscopeEvent>? _subGyro;
  StreamSubscription<MagnetometerEvent>? _subMagnet;

  double _ax = 0, _ay = 0, _az = 9.8;
  double _mx = 0, _my = 0;

  final _controlador = StreamController<LecturaOrientacion>.broadcast();
  Stream<LecturaOrientacion> get lecturas => _controlador.stream;

  void iniciar() {
    _subAccel = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen((e) {
      _ax = e.x;
      _ay = e.y;
      _az = e.z;
      _emitir();
    });

    _subGyro = gyroscopeEventStream(samplingPeriod: SensorInterval.gameInterval).listen((e) {
      final ahora = DateTime.now().microsecondsSinceEpoch;
      final anguloAccelX = inclinacionXGrados(_ax, _ay, _az);
      final anguloAccelY = inclinacionYGrados(_ax, _ay, _az);
      _filtroX.actualizar(anguloAcelerometro: anguloAccelX, velocidadAngular: e.x, microsegundos: ahora);
      _filtroY.actualizar(anguloAcelerometro: anguloAccelY, velocidadAngular: e.y, microsegundos: ahora);
      _emitir();
    });

    _subMagnet = magnetometerEventStream(samplingPeriod: SensorInterval.gameInterval).listen((e) {
      _mx = e.x;
      _my = e.y;
      _emitir();
    });
  }

  void _emitir() {
    // Azimut a partir del campo magnético en el plano XY. Válido solo con
    // el equipo plano (limitación declarada en docs/decisiones.md); la
    // compensación de inclinación con matriz de rotación queda como
    // extensión (ver guía, sección de extensiones de P6).
    var azimut = atan2(_my, _mx) * 180 / pi;
    if (azimut < 0) azimut += 360;

    _controlador.add(LecturaOrientacion(
      inclinacionX: double.parse(_filtroX.anguloActual.toStringAsFixed(1)), // RF-01: resolución 0.1°
      inclinacionY: double.parse(_filtroY.anguloActual.toStringAsFixed(1)),
      azimut: double.parse(azimut.toStringAsFixed(1)),
    ));
  }

  Future<void> detener() async {
    await _subAccel?.cancel();
    await _subGyro?.cancel();
    await _subMagnet?.cancel();
  }

  void dispose() {
    _controlador.close();
  }
}
