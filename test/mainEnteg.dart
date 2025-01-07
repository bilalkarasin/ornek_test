//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/main.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';

void main() {
  group('HomePage Integration Test', () {
    testWidgets('should display correct user information and allow updating weight and target weight',
            (WidgetTester tester) async {
          // Arrange
         // await tester.pumpWidget(MaterialApp(home: HomePage()));

          // Assert
          expect(find.text('Bilal Karaşin'), findsOneWidget);
          expect(find.text('Boy = 170 cm, Kilo = 67, Yaş = 23, Cinsiyet = Erkek'), findsOneWidget);
          expect(find.text('Yakılan Kalori: 0 kcal'), findsOneWidget);
          expect(find.text('Tüketilen Su'), findsOneWidget);
          expect(find.text('Egzersizler'), findsOneWidget);
          expect(find.text('Hedef Kilo: 65 kg'), findsOneWidget);
          expect(find.text('Vücut Kitle İndeksi: 23.2'), findsOneWidget);
          expect(find.text('Değerlendirme: Normal'), findsOneWidget);

          // Act
          await tester.tap(find.text('Kilo Güncelle'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), '72');
          await tester.tap(find.text('Güncelle'));
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Kilo = 72'), findsOneWidget);

          // Act
          await tester.tap(find.text('Hedef Kilo Ayarla'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), '68');
          await tester.tap(find.text('Kaydet'));
          await tester.pumpAndSettle();

          // Assert
          expect(find.text('Hedef Kilo: 68 kg'), findsOneWidget);
        });
  });
}
