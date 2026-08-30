import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentacion/paginas/pagina_nueva_visita.dart';

void main() {
  runApp(const ProviderScope(child: AppNivelObra()));
}

class AppNivelObra extends StatelessWidget {
  const AppNivelObra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P6 · Nivel digital de obra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const PaginaNuevaVisita(),
    );
  }
}
