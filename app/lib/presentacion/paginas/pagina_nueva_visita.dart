import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/proveedores_nucleo.dart';
import 'pagina_medicion.dart';

class PaginaNuevaVisita extends ConsumerStatefulWidget {
  const PaginaNuevaVisita({super.key});

  @override
  ConsumerState<PaginaNuevaVisita> createState() => _PaginaNuevaVisitaState();
}

class _PaginaNuevaVisitaState extends ConsumerState<PaginaNuevaVisita> {
  final _formKey = GlobalKey<FormState>();
  final _tecnicoCtrl = TextEditingController();
  final _mastilCtrl = TextEditingController();
  final _azimutCtrl = TextEditingController(text: '90');
  bool _cargando = false;
  String? _error;

  Future<void> _continuar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final repositorio = ref.read(repositorioNivelProvider);
      final visita = await repositorio.abrirVisita(
        tecnico: _tecnicoCtrl.text.trim(),
        mastil: _mastilCtrl.text.trim(),
        azimutObjetivo: double.parse(_azimutCtrl.text),
      );
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PaginaMedicion(visita: visita)));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 · Nivel digital de obra')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tecnicoCtrl,
                decoration: const InputDecoration(labelText: 'Técnico'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mastilCtrl,
                decoration: const InputDecoration(labelText: 'Identificador del mástil'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _azimutCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Azimut objetivo (0-360°)'),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  if (n == null || n < 0 || n > 360) return 'Debe ser un número entre 0 y 360';
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _cargando ? null : _continuar,
                child: _cargando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Abrir visita y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
