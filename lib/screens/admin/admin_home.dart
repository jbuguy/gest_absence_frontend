import 'package:flutter/material.dart';
import 'etudiants_screen.dart';
import 'enseignants_screen.dart';
import 'classes_screen.dart';
import 'seances_screen.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  // Liste des écrans pour la navigation
  final List<Widget> _screens = [
    AdminDashboardContent(), // Le contenu visuel que vous avez envoyé
    EtudiantsScreen(),
    EnseignantsScreen(),
    ClassesScreen(),
    SeancesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _selectedIndex == 0 
          ? AdminDashboardContent(onNavigate: (index) {
              setState(() => _selectedIndex = index);
            })
          : _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.school), label: 'Étudiants'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Enseignants'),
          NavigationDestination(icon: Icon(Icons.class_), label: 'Classes'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Séances'),
        ],
      ),
    );
  }
}

class AdminDashboardContent extends StatelessWidget {
  final Function(int)? onNavigate;

  AdminDashboardContent({this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Bonjour M. Dupont
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ADMINISTRATION", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("Bonjour, M. Dupont", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                CircleAvatar(backgroundColor: Colors.orange[100], child: Icon(Icons.person, color: Colors.orange)),
              ],
            ),
            SizedBox(height: 20),

            // Bouton Nouvelle Séance
            ElevatedButton.icon(
              onPressed: () => onNavigate?.call(4), // Redirige vers Séances
              icon: Icon(Icons.add),
              label: Text("Nouvelle Séance"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 30),

            // Cartes de statistiques (Total Étudiants, etc.)
            _buildStatCard("Total Étudiants", "1,284", Icons.group, Colors.blue, "+12% ce mois"),
            _buildStatCard("Enseignants", "48", Icons.school, Colors.orange, null),
            _buildStatCard("Absences du jour", "14", Icons.warning, Colors.red, null),
            
            SizedBox(height: 30),
            Text("Accès Rapide", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),

            // Boutons d'accès rapide (Gestion Étudiants, Enseignants, Planning)
            _buildQuickAccessItem(
              context, 
              "Gestion Étudiants", 
              "Inscriptions, Profils, Listes", 
              Icons.person_add, 
              () => onNavigate?.call(1)
            ),
            _buildQuickAccessItem(
              context, 
              "Gestion Enseignants", 
              "Planning, Affectations", 
              Icons.assignment_ind, 
              () => onNavigate?.call(2)
            ),
            _buildQuickAccessItem(
              context, 
              "Planning des Séances", 
              "Calendrier académique", 
              Icons.calendar_month, 
              () => onNavigate?.call(4)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String? trend) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey[200]!)),
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
// Remplacez la ligne de décoration par celle-ci :
decoration: BoxDecoration(
  color: color.withValues(alpha: 0.1), // Correction pour 'withOpacity'
  borderRadius: BorderRadius.circular(12),
),              child: Icon(icon, color: color),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600])),
                Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
            Spacer(),
            if (trend != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                child: Text(trend, style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title:Text(
  "Gestion Étudiants", 
  style: TextStyle(fontWeight: FontWeight.bold) // Le FontWeight doit être dans un TextStyle
),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}