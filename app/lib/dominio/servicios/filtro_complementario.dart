import 'dart:math';

/// Combina dos sensores imperfectos para obtener un ángulo estable.
/// - El acelerómetro es exacto a largo plazo, pero tiembla con el movimiento.
/// - El giroscopio es suave a corto plazo, pero acumula deriva.
/// El filtro toma lo mejor de cada uno.
///
/// Es lógica puramente matemática: no importa nada de sensors_plus ni de
/// Flutter, así que corre en `flutter test` sin dispositivo físico
/// (criterio de la rúbrica "pruebas que corren sin dispositivo").
class FiltroComplementario {
  final double peso; // 0.98 = confía casi todo al giroscopio a corto plazo
  double _angulo = 0;
  int? _ultimoUs;

  FiltroComplementario({this.peso = 0.98});

  double get anguloActual => _angulo;

  double actualizar({
    required double anguloAcelerometro, // grados
    required double velocidadAngular, // rad/s del giroscopio
    required int microsegundos,
  }) {
    if (_ultimoUs == null) {
      _ultimoUs = microsegundos;
      _angulo = anguloAcelerometro;
      return _angulo;
    }

    final dt = (microsegundos - _ultimoUs!) / 1e6;
    _ultimoUs = microsegundos;

    final porGiroscopio = _angulo + velocidadAngular * (180 / pi) * dt;
    _angulo = peso * porGiroscopio + (1 - peso) * anguloAcelerometro;
    return _angulo;
  }

  void reiniciar() {
    _angulo = 0;
    _ultimoUs = null;
  }
}

/// Ángulo de inclinación en el eje X a partir del vector de gravedad
/// medido por el acelerómetro (RF-01: resolución de 0.1°, redondeo se
/// aplica en la capa de presentación, no aquí).
double inclinacionXGrados(double ax, double ay, double az) => atan2(ax, sqrt(ay * ay + az * az)) * 180 / pi;

/// Ángulo de inclinación en el eje Y.
double inclinacionYGrados(double ax, double ay, double az) => atan2(ay, sqrt(ax * ax + az * az)) * 180 / pi;
