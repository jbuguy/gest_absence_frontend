import 'package:flutter/material.dart';

class EnseignantsScreen extends StatelessWidget {
  // Ajout du paramètre 'key' pour corriger l'avertissement
  const EnseignantsScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Enseignants")),
      body: const Center(child: Text("Liste des enseignants")),
    );
  }
}