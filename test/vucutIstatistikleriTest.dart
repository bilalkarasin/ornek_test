//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/vucutIstatistikleri.dart';


void main() {
  group('BodyStatsPage Widget Tests', () {
    testWidgets('Tüm bileşenlerin doğru görüntülenmesi', (WidgetTester tester) async {
      // Test verilerini oluştur
      final double currentWeight = 70;
      final double targetWeight = 65;
      final double bmi = 22.5;

      // Widget'ı oluştur ve teste ekle
      await tester.pumpWidget(
        MaterialApp(
          home: BodyStatsPage(
            currentWeight: currentWeight,
            targetWeight: targetWeight,
            bmi: bmi,
          ),
        ),
      );

      // Başlık kontrolü
      expect(find.text('Vücut İstatistikleri'), findsOneWidget);

      // Mevcut kilo kontrolü
      expect(find.text('Mevcut Kilo: $currentWeight kg'), findsOneWidget);

      // Hedef kilo kontrolü
      expect(find.text('Hedef Kilo: $targetWeight kg'), findsOneWidget);

      // BMI kontrolü
      expect(find.text('Vücut Kitle İndeksi: ${bmi.toStringAsFixed(1)}'), findsOneWidget);

      // Değerlendirme kontrolü
      expect(find.text('Değerlendirme: Normal'), findsOneWidget);

      // Öneri kontrolü
      expect(find.textContaining('Vücut kitle indeksiniz ideal aralıkta'), findsOneWidget);
    });

    testWidgets('BMI Zayıf durumunu doğru görüntülüyor', (WidgetTester tester) async {
      final double bmi = 17.0;

      await tester.pumpWidget(
        MaterialApp(
          home: BodyStatsPage(
            currentWeight: 50,
            targetWeight: 55,
            bmi: bmi,
          ),
        ),
      );

      expect(find.text('Değerlendirme: Zayıf'), findsOneWidget);
      expect(
        find.textContaining('Kilonuz düşük seviyede. Dengeli bir beslenme planı uygulayarak kas ve yağ kütlenizi artırmanız önerilir.'),
        findsOneWidget,
      );
    });

    testWidgets('BMI Fazla Kilolu durumunu doğru görüntülüyor', (WidgetTester tester) async {
      final double bmi = 27.0;

      await tester.pumpWidget(
        MaterialApp(
          home: BodyStatsPage(
            currentWeight: 85,
            targetWeight: 75,
            bmi: bmi,
          ),
        ),
      );

      expect(find.text('Değerlendirme: Fazla Kilolu'), findsOneWidget);
      expect(
        find.textContaining('Fazla kilonuz var. Kalori alımınızı kontrol ederek düzenli egzersiz yapmanız önerilir.'),
        findsOneWidget,
      );
    });
  });
}
