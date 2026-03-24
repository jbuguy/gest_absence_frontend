import 'package:flutter/material.dart';

class SeancesScreen extends StatelessWidget {
  // Ajout du paramètre 'key' pour corriger l'avertissement
  const SeancesScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestion Séances")),
      body: const Center(child: Text("Liste des séances")),
    );
  }
}