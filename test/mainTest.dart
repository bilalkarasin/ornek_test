//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';
import 'package:ornek_test/main.dart';

void main() {
  testWidgets('HomePage should display correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Assert
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Bilal Karaşin'), findsOneWidget);
    expect(find.text('Boy = 170 cm, Kilo = 67.0, Yaş = 23, Cinsiyet = Erkek'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Anasayfa'), findsOneWidget);
    expect(find.text('Kilo Takibi'), findsOneWidget);
    expect(find.text('Yemek Tarifleri'), findsOneWidget);
    expect(find.text('İlerleme Grafiği'), findsOneWidget);
  });

  testWidgets('Updating current weight', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Act
    await tester.tap(find.text('Kilo Güncelle'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '75.0');
    await tester.tap(find.text('Güncelle'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Mevcut Kilo: 75.0 kg'), findsOneWidget);
    expect(PersonService.persons.first.kilo, 75.0);
  });

  testWidgets('Setting target weight', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MyApp());

    // Act
    await tester.tap(find.text('Hedef Kilo Ayarla'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '68.0');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Hedef Kilo: 68.0 kg'), findsOneWidget);
  });
}
