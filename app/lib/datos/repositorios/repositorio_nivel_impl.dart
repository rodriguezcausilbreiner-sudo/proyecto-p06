import '../../dominio/contratos/repositorio_nivel.dart';
import '../../dominio/entidades/visita.dart';
import '../../dominio/entidades/medicion.dart';
import '../datasources/api_nivel_datasource.dart';

class RepositorioNivelImpl implements RepositorioNivel {
  final ApiNivelDatasource datasource;
  const RepositorioNivelImpl(this.datasource);

  @override
  Future<Visita> abrirVisita({required String tecnico, required String mastil, required double azimutObjetivo}) async {
    final json = await datasource.crearVisita(tecnico: tecnico, mastil: mastil, azimutObjetivo: azimutObjetivo);
    return Visita(id: json['id'] as String, tecnico: tecnico, mastil: mastil, azimutObjetivo: azimutObjetivo);
  }

  @override
  Future<void> subirMedicion(String visitaId, Medicion medicion) => datasource.subirMedicion(visitaId, medicion);

  @override
  Future<void> cerrarVisita(String visitaId) => datasource.cerrarVisita(visitaId);
}
