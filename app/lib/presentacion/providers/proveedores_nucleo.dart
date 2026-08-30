import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/red/cliente_dio.dart';
import '../../datos/datasources/api_nivel_datasource.dart';
import '../../datos/repositorios/repositorio_nivel_impl.dart';
import '../../datos/servicios/servicio_orientacion.dart';
import '../../dominio/contratos/repositorio_nivel.dart';

final dioProvider = Provider<Dio>((ref) => ClienteDio.crear());

final apiNivelDatasourceProvider = Provider<ApiNivelDatasource>(
  (ref) => ApiNivelDatasource(ref.watch(dioProvider)),
);

final repositorioNivelProvider = Provider<RepositorioNivel>(
  (ref) => RepositorioNivelImpl(ref.watch(apiNivelDatasourceProvider)),
);

/// autoDispose: al salir de la pantalla se cancelan las suscripciones a
/// acelerómetro/giroscopio/magnetómetro automáticamente.
final servicioOrientacionProvider = Provider.autoDispose<ServicioOrientacion>((ref) {
  final servicio = ServicioOrientacion();
  ref.onDispose(() {
    servicio.detener();
    servicio.dispose();
  });
  return servicio;
});
