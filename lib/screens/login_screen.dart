import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _stayConnected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text("GestAbsence"),
          ),
          Text(
            "Veuillez entrer vos identifiants pour accéder au tableau de bord.",
          ),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email_outlined),
              labelText: "email professionnel",
              hintText: "prenom.nom@fsb.ucar.tn",
            ),
          ),
          TextField(
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock_outlined),
              labelText: "mot de passe",
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: _stayConnected,
                onChanged: (value) =>
                    setState(() => _stayConnected = value ?? false),
              ),
              const Text("Rester connecte"),
            ],
          ),
          FilledButton(
            onPressed: () {},
            child: Row(
              children: [Text("connecter"), Icon(Icons.arrow_forward)],
            ),
          ),
        ],
      ),
    );
  }
}
