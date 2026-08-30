import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../datos/servicios/servicio_orientacion.dart';
import 'proveedores_nucleo.dart';

final lecturasOrientacionProvider = StreamProvider.autoDispose<LecturaOrientacion>((ref) {
  final servicio = ref.watch(servicioOrientacionProvider);
  servicio.iniciar();
  return servicio.lecturas;
});
