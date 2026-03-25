import 'package:flutter_test/flutter_test.dart';
import 'package:gest_absence_frontend/screens/login_screen.dart';

void main() {
  testWidgets('Test de chargement de l\'application', (
    WidgetTester tester,
  ) async {
    // Charge l'application MyApp définie dans main.dart
    await tester.pumpWidget(const LoginScreen());

    // Vérifie simplement que l'application démarre sans crash
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
