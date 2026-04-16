import 'package:flutter/material.dart';
import 'package:gest_absence_frontend/services/admin_service.dart';
import 'package:intl/intl.dart';

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
        if (snapshot.connectionState == .waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final stats = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: colorScheme.primary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ADMINISTRATION",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary.withValues(
                                alpha: 0.8,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Bonjour, M. Dupont",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => onNavigate?.call(4),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.onPrimary.withValues(
                                alpha: 0.2,
                              ),
                              foregroundColor: colorScheme.onPrimary,
                            ),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text("Nouvelle séance"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 28, 8, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Statistiques",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat("d MMMM", "fr_FR").format(DateTime.now()),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatCard(
                    title: "Total étudiants",
                    value: stats['total_etudiants'],
                    icon: Icons.group_outlined,
                    color: colorScheme.primary,
                  ),
                  _StatCard(
                    title: "Enseignants",
                    value: stats['total_enseignants'],
                    icon: Icons.school_outlined,
                    color: colorScheme.secondary,
                  ),
                  _StatCard(
                    title: "Absences du jour",
                    value: stats['absences_jour'],
                    icon: Icons.warning_amber_outlined,
                    color: colorScheme.error,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 28, 8, 16),
                    child: Text(
                      "Accès rapide",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _QuickAccessCard(
                    title: "Gestion étudiants",
                    subtitle: "Inscriptions, profils, listes",
                    icon: Icons.person_add_outlined,
                    onTap: () => onNavigate?.call(1),
                  ),
                  _QuickAccessCard(
                    title: "Gestion enseignants",
                    subtitle: "Planning, affectations",
                    icon: Icons.assignment_ind_outlined,
                    onTap: () => onNavigate?.call(2),
                  ),
                  _QuickAccessCard(
                    title: "Planning des séances",
                    subtitle: "Calendrier académique",
                    icon: Icons.calendar_month_outlined,
                    onTap: () => onNavigate?.call(4),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.chevron_right,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
        onTap: onTap,
      ),
    );
  }
}
