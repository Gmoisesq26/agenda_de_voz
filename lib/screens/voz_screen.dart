import 'package:flutter/material.dart';

class VozScreen extends StatelessWidget {
  const VozScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agenda de hoy')),
      body: const Center(child: Text('Aquí irá la agenda diaria')),
    );
  }
}
