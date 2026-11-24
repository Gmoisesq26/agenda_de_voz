import 'package:flutter/material.dart';

import '../controllers/voz_controller.dart';
import '../controllers/agenda_controller.dart';

class VozScreen extends StatelessWidget {
  const VozScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asistente de voz')),
      body: ListenableBuilder(
        listenable: Listenable.merge([voz, agenda]),
        builder: (context, _) {
          final estado = voz.estado;
          final total = agenda.deHoy.length;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  total == 0
                      ? 'No hay actividades para hoy'
                      : 'Hoy tienes $total ${total == 1 ? 'actividad' : 'actividades'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),

                // Botón principal
                GestureDetector(
                  onTap: () {
                    if (estado == EstadoVoz.detenido) {
                      voz.leer();
                    } else if (estado == EstadoVoz.leyendo) {
                      voz.pausar();
                    } else {
                      voz.reanudar();
                    }
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(
                      estado == EstadoVoz.leyendo
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 70,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(switch (estado) {
                  EstadoVoz.detenido => 'Toca para leer mi agenda',
                  EstadoVoz.leyendo => 'Leyendo...',
                  EstadoVoz.pausado => 'En pausa',
                }),
                const SizedBox(height: 32),

                // Controles secundarios
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: voz.repetir,
                      icon: const Icon(Icons.replay),
                      label: const Text('Repetir'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: estado == EstadoVoz.detenido
                          ? null
                          : voz.detener,
                      icon: const Icon(Icons.stop),
                      label: const Text('Detener'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Texto que se está leyendo
                if (estado != EstadoVoz.detenido)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        voz.fraseActual,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
