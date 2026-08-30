class Medicion {
  final double inclinacionX;
  final double inclinacionY;
  final double azimut;
  final double azimutObjetivo;
  final double latitud;
  final double longitud;
  final String rutaFotoLocal;

  const Medicion({
    required this.inclinacionX,
    required this.inclinacionY,
    required this.azimut,
    required this.azimutObjetivo,
    required this.latitud,
    required this.longitud,
    required this.rutaFotoLocal,
  });

  /// Réplica en el cliente de la regla del servidor, solo para
  /// retroalimentación inmediata en pantalla. La fuente de verdad del
  /// reporte firmado siempre es el cálculo del backend.
  bool get cumpleEnPantalla =>
      inclinacionX.abs() <= 1.5 && inclinacionY.abs() <= 1.5 && _diferenciaAngular(azimut, azimutObjetivo) <= 5;

  static double _diferenciaAngular(double a, double b) {
    final diff = (a - b).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }
}
