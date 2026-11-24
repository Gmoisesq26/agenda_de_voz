import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

import 'agenda_controller.dart';

enum EstadoVoz { detenido, leyendo, pausado }

class VozController extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();

  EstadoVoz estado = EstadoVoz.detenido;
  List<String> _frases = [];
  int _indice = 0;
  int _sesion = 0; // sirve para cancelar una lectura en curso

  String get fraseActual =>
      (_frases.isNotEmpty && _indice < _frases.length) ? _frases[_indice] : '';

  Future<void> init() async {
    await _tts.setLanguage('es-MX');
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  List<String> _construirFrases() {
    final eventos = agenda.deHoy;
    if (eventos.isEmpty) {
      return ['No tienes actividades programadas para hoy.'];
    }

    final n = eventos.length;
    final frases = <String>[
      n == 1 ? 'Hoy tienes una actividad.' : 'Hoy tienes $n actividades.',
    ];

    for (final e in eventos) {
      final hora = DateFormat('H:mm').format(e.inicio);
      var frase = 'A las $hora, ${e.titulo}.';
      if (e.descripcion.isNotEmpty) frase += ' ${e.descripcion}.';
      if (e.completado) frase += ' Ya está completada.';
      frases.add(frase);
    }
    return frases;
  }

  Future<void> leer() async {
    _frases = _construirFrases();
    _indice = 0;
    await _reproducir();
  }

  Future<void> _reproducir() async {
    final sesion = ++_sesion;
    estado = EstadoVoz.leyendo;
    notifyListeners();

    while (_indice < _frases.length) {
      await _tts.speak(_frases[_indice]);
      if (sesion != _sesion) return; // se pausó, detuvo o repitió
      _indice++;
      notifyListeners();
    }

    estado = EstadoVoz.detenido;
    _indice = 0;
    notifyListeners();
  }

  Future<void> pausar() async {
    if (estado != EstadoVoz.leyendo) return;
    _sesion++;
    await _tts.stop();
    estado = EstadoVoz.pausado;
    notifyListeners();
  }

  Future<void> reanudar() async {
    if (estado != EstadoVoz.pausado) return;
    await _reproducir();
  }

  Future<void> repetir() async {
    _sesion++;
    await _tts.stop();
    await leer();
  }

  Future<void> detener() async {
    _sesion++;
    await _tts.stop();
    estado = EstadoVoz.detenido;
    _indice = 0;
    notifyListeners();
  }
}

final voz = VozController();
