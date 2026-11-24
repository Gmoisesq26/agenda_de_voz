import 'package:flutter/material.dart';

import '../screens/inicio_screen.dart';
import '../screens/voz_screen.dart';
import '../screens/actividades_screen.dart';
import '../screens/calendarios_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;

  final _pantallas = const [
    InicioScreen(),
    VozScreen(),
    ActividadesScreen(),
    CalendariosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indice],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Inicio'),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over),
            label: 'Voz',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist),
            label: 'Actividades',
          ),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Calendarios'),
        ],
      ),
    );
  }
}
