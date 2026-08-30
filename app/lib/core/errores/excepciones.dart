library;

class SinPermisoCamara implements Exception {
  final String mensaje;
  const SinPermisoCamara([this.mensaje = 'Se requiere permiso de cámara para tomar la evidencia.']);
  @override
  String toString() => mensaje;
}

class SinPermisoUbicacion implements Exception {
  final String mensaje;
  const SinPermisoUbicacion([this.mensaje = 'Se requiere permiso de ubicación.']);
  @override
  String toString() => mensaje;
}

class SensorNoDisponible implements Exception {
  final String sensor;
  const SensorNoDisponible(this.sensor);
  @override
  String toString() => 'El sensor $sensor no está disponible en este equipo.';
}

class ErrorRed implements Exception {
  final String mensaje;
  const ErrorRed(this.mensaje);
  @override
  String toString() => mensaje;
}
