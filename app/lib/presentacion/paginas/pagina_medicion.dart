import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/permisos/gestor_permisos.dart';
import '../../datos/servicios/quemador_overlay.dart';
import '../../dominio/entidades/medicion.dart';
import '../../dominio/entidades/visita.dart';
import '../providers/provider_orientacion.dart';
import '../providers/proveedores_nucleo.dart';
import '../widgets/overlay_orientacion.dart';

class PaginaMedicion extends ConsumerStatefulWidget {
  final Visita visita;
  const PaginaMedicion({super.key, required this.visita});

  @override
  ConsumerState<PaginaMedicion> createState() => _PaginaMedicionState();
}

class _PaginaMedicionState extends ConsumerState<PaginaMedicion> {
  CameraController? _controladorCamara;
  final _permisos = GestorPermisos();
  final _quemador = QuemadorOverlay();
  bool _capturando = false;
  int _medicionesGuardadas = 0;
  String? _mensaje;

  @override
  void initState() {
    super.initState();
    _inicializarCamara();
  }

  Future<void> _inicializarCamara() async {
    try {
      await _permisos.asegurarUbicacion();
      final camaras = await availableCameras();
      if (camaras.isEmpty) {
        setState(() => _mensaje = 'No se encontró ninguna cámara en este equipo.');
        return;
      }
      final controlador = CameraController(camaras.first, ResolutionPreset.medium, enableAudio: false);
      await controlador.initialize();
      if (!mounted) return;
      setState(() => _controladorCamara = controlador);
    } catch (e) {
      setState(() => _mensaje = 'No se pudo iniciar la cámara: $e');
    }
  }

  Future<void> _capturarYSubir(dynamic lectura) async {
    final controlador = _controladorCamara;
    if (controlador == null || !controlador.value.isInitialized || _capturando) return;

    setState(() => _capturando = true);
    try {
      final posicion = await Geolocator.getCurrentPosition().timeout(const Duration(seconds: 5));
      final archivo = await controlador.takePicture();

      final rutaAnotada = await _quemador.grabarSobreImagen(
        rutaOriginal: archivo.path,
        lineas: [
          'X: ${lectura.inclinacionX.toStringAsFixed(1)}  Y: ${lectura.inclinacionY.toStringAsFixed(1)}',
          'Azimut: ${lectura.azimut.toStringAsFixed(1)} / obj ${widget.visita.azimutObjetivo.toStringAsFixed(0)}',
        ],
      );

      final medicion = Medicion(
        inclinacionX: lectura.inclinacionX,
        inclinacionY: lectura.inclinacionY,
        azimut: lectura.azimut,
        azimutObjetivo: widget.visita.azimutObjetivo,
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        rutaFotoLocal: rutaAnotada,
      );

      await ref.read(repositorioNivelProvider).subirMedicion(widget.visita.id, medicion);

      setState(() {
        _medicionesGuardadas++;
        _mensaje = medicion.cumpleEnPantalla ? 'Medición guardada: dentro de tolerancia' : 'Medición guardada: fuera de tolerancia';
      });
    } catch (e) {
      setState(() => _mensaje = 'No se pudo guardar la medición: $e');
    } finally {
      if (mounted) setState(() => _capturando = false);
    }
  }

  @override
  void dispose() {
    _controladorCamara?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lecturaAsync = ref.watch(lecturasOrientacionProvider);
    final controlador = _controladorCamara;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mástil ${widget.visita.mastil}'),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(repositorioNivelProvider).cerrarVisita(widget.visita.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Cerrar visita', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: controlador == null || !controlador.value.isInitialized
          ? Center(child: Text(_mensaje ?? 'Iniciando cámara…', textAlign: TextAlign.center))
          : Stack(
              children: [
                Positioned.fill(child: CameraPreview(controlador)),
                lecturaAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Text('Sensores no disponibles: $e', style: const TextStyle(color: Colors.red)),
                  ),
                  data: (lectura) {
                    final medicionPreliminar = Medicion(
                      inclinacionX: lectura.inclinacionX,
                      inclinacionY: lectura.inclinacionY,
                      azimut: lectura.azimut,
                      azimutObjetivo: widget.visita.azimutObjetivo,
                      latitud: 0,
                      longitud: 0,
                      rutaFotoLocal: '',
                    );
                    return Stack(
                      children: [
                        OverlayOrientacion(
                          lectura: lectura,
                          azimutObjetivo: widget.visita.azimutObjetivo,
                          cumple: medicionPreliminar.cumpleEnPantalla,
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            children: [
                              if (_mensaje != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(_mensaje!, style: const TextStyle(color: Colors.white)),
                                ),
                              FilledButton.icon(
                                onPressed: _capturando ? null : () => _capturarYSubir(lectura),
                                icon: _capturando
                                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.camera_alt),
                                label: Text('Capturar medición ($_medicionesGuardadas guardadas)'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
