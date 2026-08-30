import 'package:flutter/material.dart';
import '../../datos/servicios/servicio_orientacion.dart';

class OverlayOrientacion extends StatelessWidget {
  final LecturaOrientacion lectura;
  final double azimutObjetivo;
  final bool cumple;

  const OverlayOrientacion({
    super.key,
    required this.lectura,
    required this.azimutObjetivo,
    required this.cumple,
  });

  @override
  Widget build(BuildContext context) {
    final color = cumple ? Colors.greenAccent : Colors.amberAccent;

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fila('Inclinación X', '${lectura.inclinacionX.toStringAsFixed(1)}°'),
            _fila('Inclinación Y', '${lectura.inclinacionY.toStringAsFixed(1)}°'),
            _fila('Azimut', '${lectura.azimut.toStringAsFixed(1)}° (objetivo ${azimutObjetivo.toStringAsFixed(0)}°)'),
            const SizedBox(height: 6),
            Text(
              cumple ? 'DENTRO DE TOLERANCIA' : 'FUERA DE TOLERANCIA',
              style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String etiqueta, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(etiqueta, style: const TextStyle(color: Colors.white70)),
            Text(valor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
