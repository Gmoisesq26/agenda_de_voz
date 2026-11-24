import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/evento.dart';

class EventoRepository {
  static const _clave = 'eventos';

  Future<List<Evento>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);
    if (texto == null) return [];
    final lista = jsonDecode(texto) as List;
    return lista.map((e) => Evento.fromJson(e)).toList();
  }

  Future<void> guardar(List<Evento> eventos) async {
    final prefs = await SharedPreferences.getInstance();
    final texto = jsonEncode(eventos.map((e) => e.toJson()).toList());
    await prefs.setString(_clave, texto);
  }
}
