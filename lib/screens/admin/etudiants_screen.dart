import 'package:flutter/material.dart';

class EtudiantsScreen extends StatelessWidget {
  // Ajout du paramètre 'key' pour corriger l'avertissement
  const EtudiantsScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Étudiants")),
      body: const Center(child: Text("Liste des étudiants")),
    );
  }
}