import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  // Ajout du paramètre 'key' pour corriger l'avertissement
  const ClassesScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Classes")),
      body: const Center(child: Text("Liste des classes")),
    );
  }
}