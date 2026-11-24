import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/agenda_controller.dart';
import '../widgets/evento_tile.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fechaHoy = DateFormat(
      "EEEE d 'de' MMMM",
      'es_MX',
    ).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de hoy')),
      body: ListenableBuilder(
        listenable: agenda,
        builder: (context, _) {
          final eventos = agenda.deHoy;
          final hechos = eventos.where((e) => e.completado).length;
          final progreso = eventos.isEmpty ? 0.0 : hechos / eventos.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fechaHoy,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: progreso, minHeight: 8),
                    const SizedBox(height: 4),
                    Text('$hechos de ${eventos.length} completadas'),
                  ],
                ),
              ),
              Expanded(
                child: eventos.isEmpty
                    ? const Center(
                        child: Text('No tienes actividades para hoy'),
                      )
                    : ListView.builder(
                        itemCount: eventos.length,
                        itemBuilder: (_, i) => EventoTile(evento: eventos[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
