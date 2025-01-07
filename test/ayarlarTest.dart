//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/ayarlar.dart';
//import 'package:ornek_test/settings_page.dart';



void main() {
  testWidgets('SettingsPage should display correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsPage(),
      ),
    );

    // Assert
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
    expect(find.text('Ayarlar Burada Görüntülenecek.'), findsOneWidget);
  });
}
