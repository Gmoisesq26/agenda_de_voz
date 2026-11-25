import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../models/evento.dart';

class GoogleCalendarService {
  static const _scopes = ['https://www.googleapis.com/auth/calendar.readonly'];

  // ID de cliente de tipo "Aplicación web" (paso 4 de Google Cloud)
  static const _serverClientId =
      '749977102291-rn40fama4dajq9eu2tilkkoa57vsq6ct.apps.googleusercontent.com';

  GoogleSignInAccount? _usuario;
  bool _inicializado = false;

  bool get conectado => _usuario != null;
  String? get correo => _usuario?.email;

  Future<void> _init() async {
    if (_inicializado) return;
    await GoogleSignIn.instance.initialize(serverClientId: _serverClientId);
    _inicializado = true;
  }

  /// Intenta recuperar la sesión al abrir la app (sin mostrar pantallas).
  Future<void> restaurarSesion() async {
    try {
      await _init();
      _usuario = await GoogleSignIn.instance.attemptLightweightAuthentication();
    } catch (_) {
      _usuario = null;
    }
  }

  Future<void> conectar() async {
    await _init();
    final usuario = await GoogleSignIn.instance.authenticate();
    // Pide el permiso del calendario en este momento (viene de un botón)
    await usuario.authorizationClient.authorizeScopes(_scopes);
    _usuario = usuario;
  }

  Future<void> desconectar() async {
    await _init();
    await GoogleSignIn.instance.signOut();
    _usuario = null;
  }

  Future<List<Evento>> obtenerEventos(DateTime desde, DateTime hasta) async {
    final usuario = _usuario;
    if (usuario == null) throw Exception('Google Calendar no está conectado');

    final auth =
        await usuario.authorizationClient.authorizationForScopes(_scopes) ??
        await usuario.authorizationClient.authorizeScopes(_scopes);

    final uri = Uri.https(
      'www.googleapis.com',
      '/calendar/v3/calendars/primary/events',
      {
        'timeMin': desde.toUtc().toIso8601String(),
        'timeMax': hasta.toUtc().toIso8601String(),
        'singleEvents': 'true',
        'orderBy': 'startTime',
        'maxResults': '100',
      },
    );

    final respuesta = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${auth.accessToken}'},
    );

    if (respuesta.statusCode != 200) {
      throw Exception('Google Calendar respondió ${respuesta.statusCode}');
    }

    final items = (jsonDecode(respuesta.body)['items'] as List?) ?? [];
    final eventos = <Evento>[];

    for (final item in items) {
      if (item['status'] == 'cancelled') continue;

      final inicio = _leerFecha(item['start']);
      if (inicio == null) continue;

      eventos.add(
        Evento(
          id: 'google:${item['id']}',
          titulo: (item['summary'] as String?) ?? '(Sin título)',
          descripcion: (item['description'] as String?) ?? '',
          inicio: inicio,
          fin: _leerFecha(item['end']),
          origen: OrigenCalendario.google,
        ),
      );
    }
    return eventos;
  }

  // Los eventos normales traen "dateTime"; los de todo el día traen "date".
  DateTime? _leerFecha(Map<String, dynamic>? campo) {
    if (campo == null) return null;
    if (campo['dateTime'] != null) {
      return DateTime.parse(campo['dateTime']).toLocal();
    }
    if (campo['date'] != null) return DateTime.parse(campo['date']);
    return null;
  }
}

final googleCalendar = GoogleCalendarService();
