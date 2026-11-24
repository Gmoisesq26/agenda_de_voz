enum OrigenCalendario { local, google, outlook }

class Evento {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime inicio;
  final DateTime? fin;
  final OrigenCalendario origen;
  bool completado;

  Evento({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    required this.inicio,
    this.fin,
    this.origen = OrigenCalendario.local,
    this.completado = false,
  });

  String get nombreOrigen {
    switch (origen) {
      case OrigenCalendario.google:
        return 'Google Calendar';
      case OrigenCalendario.outlook:
        return 'Outlook';
      case OrigenCalendario.local:
        return 'Local';
    }
  }
}
