import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../errores/excepciones.dart';

class GestorPermisos {
  Future<void> asegurarCamara() async {
    final estado = await ph.Permission.camera.request();
    if (!estado.isGranted) throw const SinPermisoCamara();
  }

  Future<void> asegurarUbicacion() async {
    final servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      throw const SinPermisoUbicacion('Activa el GPS del dispositivo para continuar.');
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
      throw const SinPermisoUbicacion();
    }
  }
}
