import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'controllers/agenda_controller.dart';
import 'widgets/home_shell.dart';
import 'controllers/voz_controller.dart';
import 'services/google_calendar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_MX');
  await agenda.cargar();
  await voz.init();
  await googleCalendar.restaurarSesion();
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
