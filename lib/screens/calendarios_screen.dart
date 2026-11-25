import 'package:flutter/material.dart';

import '../controllers/agenda_controller.dart';
import '../models/evento.dart';
import '../services/google_calendar_service.dart';

class CalendariosScreen extends StatefulWidget {
  const CalendariosScreen({super.key});

  @override
  State<CalendariosScreen> createState() => _CalendariosScreenState();
}

class _CalendariosScreenState extends State<CalendariosScreen> {
  bool _cargando = false;

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _ejecutar(Future<void> Function() accion, String exito) async {
    setState(() => _cargando = true);
    try {
      await accion();
      if (mounted) _mensaje(exito);
    } catch (e) {
      if (mounted) _mensaje('Error: $e');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _sincronizarGoogle() async {
    final ahora = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month, ahora.day);
    final eventos = await googleCalendar.obtenerEventos(
      inicio,
      inicio.add(const Duration(days: 30)),
    );
    await agenda.reemplazarEventosDe(OrigenCalendario.google, eventos);
  }

  @override
  Widget build(BuildContext context) {
    final conectado = googleCalendar.conectado;

    return Scaffold(
      appBar: AppBar(title: const Text('Calendarios')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (_cargando) const LinearProgressIndicator(),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event, size: 32),
                    title: const Text('Google Calendar'),
                    subtitle: Text(
                      conectado
                          ? 'Conectado: ${googleCalendar.correo}'
                          : 'No conectado',
                    ),
                  ),
                  if (!conectado)
                    FilledButton.icon(
                      onPressed: _cargando
                          ? null
                          : () => _ejecutar(() async {
                              await googleCalendar.conectar();
                              await _sincronizarGoogle();
                            }, 'Google Calendar conectado'),
                      icon: const Icon(Icons.link),
                      label: const Text('Conectar'),
                    )
                  else
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: _cargando
                              ? null
                              : () => _ejecutar(
                                  _sincronizarGoogle,
                                  'Eventos actualizados',
                                ),
                          icon: const Icon(Icons.sync),
                          label: const Text('Sincronizar'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _cargando
                              ? null
                              : () => _ejecutar(() async {
                                  await googleCalendar.desconectar();
                                  await agenda.reemplazarEventosDe(
                                    OrigenCalendario.google,
                                    [],
                                  );
                                }, 'Cuenta desconectada'),
                          child: const Text('Desconectar'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.mail_outline, size: 32),
              title: Text('Outlook / Microsoft 365'),
              subtitle: Text('Próximamente (siguiente paso)'),
            ),
          ),
        ],
      ),
    );
  }
}
