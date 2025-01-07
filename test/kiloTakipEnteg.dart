//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/kiloTakibi.dart';
import 'package:ornek_test/personService.dart';

void main() {
  group('KiloTakibiPage Integration Test', () {
    testWidgets('should add new weight record and display it in the list',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(MaterialApp(home: KiloTakibiPage(initialWeight: 67.0)));

          // Act
          await tester.tap(find.text('Yeni Kilo Kaydı Ekle'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), '70.0');
          await tester.tap(find.text('Ekle'));
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Mevcut Kilo: 70.0 kg'), findsOneWidget);
          expect(find.text('Tarih:'), findsOneWidget);
          expect(find.text('Kilo: 70.0 kg'), findsOneWidget);
        });

    testWidgets('should delete a weight record from the list',
            (WidgetTester tester) async {
          // Arrange
          await tester.pumpWidget(MaterialApp(home: KiloTakibiPage(initialWeight: 67.0)));

          // Act
          await tester.tap(find.text('Yeni Kilo Kaydı Ekle'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), '70.0');
          await tester.tap(find.text('Ekle'));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.delete));
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Tarih:'), findsNothing);
          expect(find.text('Kilo: 70.0 kg'), findsNothing);
        });
  });
}
