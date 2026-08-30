import 'package:flutter_test/flutter_test.dart';
import 'package:p6_nivel_digital_obra/dominio/servicios/filtro_complementario.dart';

void main() {
  group('FiltroComplementario', () {
    test('la primera lectura fija el ángulo directamente desde el acelerómetro', () {
      final filtro = FiltroComplementario();
      final angulo = filtro.actualizar(anguloAcelerometro: 5.0, velocidadAngular: 0, microsegundos: 1000000);
      expect(angulo, 5.0);
    });

    test('integra la velocidad angular del giroscopio entre lecturas', () {
      final filtro = FiltroComplementario(peso: 1.0); // confía 100% en el giroscopio para aislar el cálculo
      filtro.actualizar(anguloAcelerometro: 0.0, velocidadAngular: 0, microsegundos: 0);
      // 0.1 rad/s durante 1s ≈ 5.73°
      final angulo = filtro.actualizar(anguloAcelerometro: 0.0, velocidadAngular: 0.1, microsegundos: 1000000);
      expect(angulo, closeTo(5.73, 0.1));
    });

    test('con peso 0 ignora el giroscopio y sigue solo al acelerómetro', () {
      final filtro = FiltroComplementario(peso: 0.0);
      filtro.actualizar(anguloAcelerometro: 0.0, velocidadAngular: 999, microsegundos: 0);
      final angulo = filtro.actualizar(anguloAcelerometro: 10.0, velocidadAngular: 999, microsegundos: 500000);
      expect(angulo, 10.0);
    });

    test('reiniciar() borra el estado acumulado', () {
      final filtro = FiltroComplementario();
      filtro.actualizar(anguloAcelerometro: 20.0, velocidadAngular: 0, microsegundos: 0);
      filtro.reiniciar();
      final angulo = filtro.actualizar(anguloAcelerometro: 3.0, velocidadAngular: 0, microsegundos: 100);
      expect(angulo, 3.0, reason: 'tras reiniciar, la siguiente lectura debe fijar el ángulo desde cero');
    });
  });

  group('inclinacionXGrados / inclinacionYGrados', () {
    test('equipo perfectamente plano reporta 0° en ambos ejes', () {
      expect(inclinacionXGrados(0, 0, 9.8), closeTo(0, 0.01));
      expect(inclinacionYGrados(0, 0, 9.8), closeTo(0, 0.01));
    });

    test('inclinación de 90° en X cuando el eje X coincide con la gravedad', () {
      expect(inclinacionXGrados(9.8, 0, 0), closeTo(90, 0.5));
    });
  });
}
