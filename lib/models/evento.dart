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

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'inicio': inicio.toIso8601String(),
    'fin': fin?.toIso8601String(),
    'origen': origen.name,
    'completado': completado,
  };

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'] ?? '',
    inicio: DateTime.parse(json['inicio']),
    fin: json['fin'] != null ? DateTime.parse(json['fin']) : null,
    origen: OrigenCalendario.values.byName(json['origen']),
    completado: json['completado'] ?? false,
  );
}
