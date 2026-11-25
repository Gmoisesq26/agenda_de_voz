import 'package:flutter/material.dart';

import '../controllers/agenda_controller.dart';
import '../models/evento.dart';
import '../widgets/evento_tile.dart';

class ActividadesScreen extends StatelessWidget {
  const ActividadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Actividades'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pendientes'),
              Tab(text: 'Realizadas'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _mostrarFormulario(context),
          child: const Icon(Icons.add),
        ),
        body: ListenableBuilder(
          listenable: agenda,
          builder: (context, _) => TabBarView(
            children: [
              _lista(agenda.pendientes, 'No hay actividades pendientes'),
              _lista(agenda.realizadas, 'Aún no has completado actividades'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lista(List<Evento> eventos, String vacio) {
    if (eventos.isEmpty) return Center(child: Text(vacio));
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (_, i) {
        final e = eventos[i];
        return Dismissible(
          key: ValueKey(e.id),
          direction: e.origen == OrigenCalendario.local
              ? DismissDirection.endToStart
              : DismissDirection.none,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => agenda.eliminar(e),
          child: EventoTile(evento: e, mostrarFecha: true),
        );
      },
    );
  }

  void _mostrarFormulario(BuildContext context) {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime fecha = DateTime.now();
    TimeOfDay hora = TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text('${fecha.day}/${fecha.month}/${fecha.year}'),
                      onPressed: () async {
                        final f = await showDatePicker(
                          context: ctx,
                          initialDate: fecha,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (f != null) setState(() => fecha = f);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(hora.format(ctx)),
                      onPressed: () async {
                        final h = await showTimePicker(
                          context: ctx,
                          initialTime: hora,
                        );
                        if (h != null) setState(() => hora = h);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  if (tituloCtrl.text.trim().isEmpty) return;
                  agenda.agregar(
                    Evento(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      titulo: tituloCtrl.text.trim(),
                      descripcion: descCtrl.text.trim(),
                      inicio: DateTime(
                        fecha.year,
                        fecha.month,
                        fecha.day,
                        hora.hour,
                        hora.minute,
                      ),
                    ),
                  );
                  Navigator.pop(ctx);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
