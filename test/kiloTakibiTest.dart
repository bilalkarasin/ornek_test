import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/kiloTakibi.dart';
import 'package:ornek_test/personService.dart';

void main() {
  testWidgets('KiloTakibiPage should display correctly', (WidgetTester tester) async {
    // Arrange
    final initialWeight = 70.0;
    await tester.pumpWidget(
      MaterialApp(
        home: KiloTakibiPage(
          initialWeight: initialWeight,
        ),
      ),
    );

    // Assert
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Kilo Takibi'), findsOneWidget);
    expect(find.text('Mevcut Kilo: $initialWeight kg'), findsOneWidget);
    expect(find.text('Yeni Kilo Kaydı Ekle'), findsOneWidget);
    expect(find.text('Kilo Geçmişi'), findsOneWidget);
  });

  testWidgets('Adding a new weight record', (WidgetTester tester) async {
    // Arrange
    final initialWeight = 70.0;
    await tester.pumpWidget(
      MaterialApp(
        home: KiloTakibiPage(
          initialWeight: initialWeight,
        ),
      ),
    );

    // Act
    await tester.tap(find.text('Yeni Kilo Kaydı Ekle'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '75.0');
    await tester.tap(find.text('Ekle'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Mevcut Kilo: 75.0 kg'), findsOneWidget);
    expect(PersonService.persons.first.kilo, 75.0);
  });

  testWidgets('Deleting a weight record', (WidgetTester tester) async {
    // Arrange
    final initialWeight = 70.0;
    await tester.pumpWidget(
      MaterialApp(
        home: KiloTakibiPage(
          initialWeight: initialWeight,
        ),
      ),
    );

    // Act
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Mevcut Kilo: 70.0 kg'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsNothing);
  });
}
