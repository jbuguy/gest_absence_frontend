import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/services/admin_service.dart';

class AdminDashboardContent extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const AdminDashboardContent({super.key, this.onNavigate});

  Future<Map<String, dynamic>> _fetchStats() async {
    final adminService = AdminService();
    try {
      final data = await adminService.getStats();
      return {
        "total_etudiants": (data['total_etudiants']).toString(),
        "total_enseignants": (data['total_enseignants']).toString(),
        "absences_jour": (data['absences_jour']).toString(),
      };
    } catch (e) {
      return {
        "total_etudiants": "0",
        "total_enseignants": "0",
        "absences_jour": "0",
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Erreur lors du chargement des statistiques",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "Aucune donnée disponible",
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        final stats = snapshot.data!;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ADMINISTRATION",
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          "Bonjour, M. Dupont",
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primaryContainer,
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.person,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Button
                FilledButton.icon(
                  onPressed: () => onNavigate?.call(4),
                  icon: const Icon(Icons.add),
                  label: const Text("Nouvelle Séance"),
                ),
                const SizedBox(height: 32),

                // Statistics Cards
                _buildStatCard(
                  context,
                  "Total Étudiants",
                  stats['total_etudiants'],
                  Icons.group,
                  colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  "Enseignants",
                  stats['total_enseignants'],
                  Icons.school,
                  colorScheme.secondary,
                ),
                _buildStatCard(
                  context,
                  "Absences du jour",
                  stats['absences_jour'],
                  Icons.warning,
                  colorScheme.tertiary,
                ),

                const SizedBox(height: 32),

                // Quick Access Section
                Text("Accès Rapide", style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),

                _buildQuickAccessItem(
                  context,
                  "Gestion Étudiants",
                  "Inscriptions, Profils, Listes",
                  Icons.person_add,
                  () => onNavigate?.call(1),
                ),
                _buildQuickAccessItem(
                  context,
                  "Gestion Enseignants",
                  "Planning, Affectations",
                  Icons.assignment_ind,
                  () => onNavigate?.call(2),
                ),
                _buildQuickAccessItem(
                  context,
                  "Planning des Séances",
                  "Calendrier académique",
                  Icons.calendar_month,
                  () => onNavigate?.call(4),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHigh,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title, style: theme.textTheme.labelLarge),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
      ),
    );
  }
}
