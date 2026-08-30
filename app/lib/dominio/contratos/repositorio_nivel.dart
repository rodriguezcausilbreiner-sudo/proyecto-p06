import '../entidades/visita.dart';
import '../entidades/medicion.dart';

abstract class RepositorioNivel {
  Future<Visita> abrirVisita({required String tecnico, required String mastil, required double azimutObjetivo});
  Future<void> subirMedicion(String visitaId, Medicion medicion);
  Future<void> cerrarVisita(String visitaId);
}
