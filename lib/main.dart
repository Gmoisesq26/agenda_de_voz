import 'package:flutter/material.dart';

import 'widgets/home_shell.dart';

void main() {
  runApp(const AgendaDeVozApp());
}

class AgendaDeVozApp extends StatelessWidget {
  const AgendaDeVozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Voz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeShell(),
    );
  }
}
