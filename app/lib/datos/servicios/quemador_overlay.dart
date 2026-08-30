import 'dart:io';
import 'package:image/image.dart' as img;

/// Recibe la ruta de la foto recién capturada y graba encima el texto con
/// las mediciones, para que la evidencia (RF-04) no dependa de que nadie
/// recuerde los valores mostrados en pantalla en ese instante.
class QuemadorOverlay {
  Future<String> grabarSobreImagen({
    required String rutaOriginal,
    required List<String> lineas,
  }) async {
    final bytes = await File(rutaOriginal).readAsBytes();
    final imagen = img.decodeImage(bytes);
    if (imagen == null) return rutaOriginal; // degradación: se sube la foto sin overlay antes que fallar

    var y = 24;
    for (final linea in lineas) {
      img.drawString(imagen, linea, font: img.arial24, x: 24, y: y, color: img.ColorRgb8(0, 255, 120));
      y += 32;
    }

    final rutaFinal = rutaOriginal.replaceFirst('.jpg', '_anotada.jpg');
    await File(rutaFinal).writeAsBytes(img.encodeJpg(imagen, quality: 85));
    return rutaFinal;
  }
}
