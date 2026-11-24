import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../controllers/agenda_controller.dart';
import '../models/evento.dart';

class EventoTile extends StatelessWidget {
  final Evento evento;
  final bool mostrarFecha;

  const EventoTile({
    super.key,
    required this.evento,
    this.mostrarFecha = false,
  });

  @override
  Widget build(BuildContext context) {
    final hora = DateFormat('HH:mm').format(evento.inicio);
    final fecha = DateFormat('d MMM', 'es_MX').format(evento.inicio);
    final horario = mostrarFecha ? '$fecha · $hora' : hora;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: evento.completado,
          onChanged: (_) => agenda.alternarCompletado(evento),
        ),
        title: Text(
          evento.titulo,
          style: TextStyle(
            decoration: evento.completado ? TextDecoration.lineThrough : null,
            color: evento.completado ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          [
            '$horario · ${evento.nombreOrigen}',
            if (evento.descripcion.isNotEmpty) evento.descripcion,
          ].join('\n'),
        ),
        isThreeLine: evento.descripcion.isNotEmpty,
      ),
    );
  }
}
