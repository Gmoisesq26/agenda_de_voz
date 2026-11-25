import 'package:flutter/foundation.dart';

import '../models/evento.dart';
import '../repositories/evento_repository.dart';

class AgendaController extends ChangeNotifier {
  final EventoRepository _repo = EventoRepository();
  List<Evento> _eventos = [];

  List<Evento> get todos {
    final copia = [..._eventos];
    copia.sort((a, b) => a.inicio.compareTo(b.inicio));
    return copia;
  }

  List<Evento> get deHoy {
    final ahora = DateTime.now();
    return todos
        .where(
          (e) =>
              e.inicio.year == ahora.year &&
              e.inicio.month == ahora.month &&
              e.inicio.day == ahora.day,
        )
        .toList();
  }

  List<Evento> get pendientes => todos.where((e) => !e.completado).toList();
  List<Evento> get realizadas => todos.where((e) => e.completado).toList();

  Future<void> cargar() async {
    _eventos = await _repo.cargar();
    notifyListeners();
  }

  Future<void> agregar(Evento evento) async {
    _eventos.add(evento);
    await _repo.guardar(_eventos);
    notifyListeners();
  }

  Future<void> alternarCompletado(Evento evento) async {
    evento.completado = !evento.completado;
    await _repo.guardar(_eventos);
    notifyListeners();
  }

  Future<void> eliminar(Evento evento) async {
    _eventos.removeWhere((e) => e.id == evento.id);
    await _repo.guardar(_eventos);
    notifyListeners();
  }

  /// Reemplaza todos los eventos de un calendario externo conservando
  /// el estado "completado" de los que ya existían (ese dato es solo local).
  Future<void> reemplazarEventosDe(
    OrigenCalendario origen,
    List<Evento> nuevos,
  ) async {
    final previos = {
      for (final e in _eventos.where((e) => e.origen == origen))
        e.id: e.completado,
    };

    _eventos.removeWhere((e) => e.origen == origen);

    for (final nuevo in nuevos) {
      nuevo.completado = previos[nuevo.id] ?? false;
      _eventos.add(nuevo);
    }

    await _repo.guardar(_eventos);
    notifyListeners();
  }
}

// Instancia global sencilla para el proyecto.
final agenda = AgendaController();
