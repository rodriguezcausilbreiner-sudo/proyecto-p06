import 'package:dio/dio.dart';
import '../../core/errores/excepciones.dart';
import '../../dominio/entidades/medicion.dart';

class ApiNivelDatasource {
  final Dio dio;
  const ApiNivelDatasource(this.dio);

  Future<Map<String, dynamic>> crearVisita({
    required String tecnico,
    required String mastil,
    required double azimutObjetivo,
  }) async {
    try {
      final r = await dio.post('/visitas', data: {
        'tecnico': tecnico,
        'mastil': mastil,
        'azimutObjetivo': azimutObjetivo,
      });
      return r.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  /// Foto + mediciones en una sola petición multipart (RF-05).
  Future<void> subirMedicion(String visitaId, Medicion m) async {
    try {
      final formulario = FormData.fromMap({
        'inclinacionX': m.inclinacionX.toString(),
        'inclinacionY': m.inclinacionY.toString(),
        'azimut': m.azimut.toString(),
        'azimutObjetivo': m.azimutObjetivo.toString(),
        'latitud': m.latitud.toString(),
        'longitud': m.longitud.toString(),
        'foto': await MultipartFile.fromFile(m.rutaFotoLocal, filename: 'evidencia.jpg'),
      });
      await dio.post('/visitas/$visitaId/mediciones', data: formulario);
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  Future<void> cerrarVisita(String visitaId) async {
    try {
      await dio.patch('/visitas/$visitaId/cerrar');
    } on DioException catch (e) {
      throw ErrorRed(_mensajeDe(e));
    }
  }

  String _mensajeDe(DioException e) {
    if (e.response?.data is Map && e.response?.data['error'] != null) {
      return e.response!.data['error'] as String;
    }
    return e.message ?? 'Error de red desconocido';
  }
}
