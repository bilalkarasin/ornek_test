//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/yemekTarifi.dart';

void main() {
  group('FoodRecipesPage', () {
    testWidgets('should display recipe list correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: FoodRecipesPage()));

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Yemek Tarifleri'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(6));
      expect(find.text('Köfte'), findsOneWidget);
      expect(find.text('Makarna'), findsOneWidget);
      expect(find.text('Salata'), findsOneWidget);
      expect(find.text('Çorba'), findsOneWidget);
      expect(find.text('Pilav'), findsOneWidget);
      expect(find.text('Izgara Balık'), findsOneWidget);
    });

    testWidgets('should navigate to recipe detail page', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: FoodRecipesPage()));

      // Act
      await tester.tap(find.text('Köfte'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FoodRecipeDetailPage), findsOneWidget);
      expect(find.text('Köfte'), findsOneWidget);
    });
  });

  group('FoodRecipeDetailPage', () {
    testWidgets('should display recipe details correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(
        home: FoodRecipeDetailPage(
          recipeName: 'Köfte',
          ingredients: [
            '500g kıyma',
            '1 adet soğan',
            '1 dilim bayat ekmek',
            '1 yumurta',
            'Tuz, karabiber'
          ],
          steps: [
            'Kıymayı bir kapta yoğurun.',
            'Soğanı rendeleyin ve ekleyin.',
            'Baharatları ekleyin ve köfte şekli verin.',
            'Kızartın veya fırınlayın.'
          ],
        ),
      ));

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Köfte'), findsOneWidget);
      expect(find.text('Malzemeler'), findsOneWidget);
      expect(find.text('500g kıyma'), findsOneWidget);
      expect(find.text('1 adet soğan'), findsOneWidget);
      expect(find.text('1 dilim bayat ekmek'), findsOneWidget);
      expect(find.text('1 yumurta'), findsOneWidget);
      expect(find.text('Tuz, karabiber'), findsOneWidget);
      expect(find.text('Yapılışı'), findsOneWidget);
      expect(find.text('Kıymayı bir kapta yoğurun.'), findsOneWidget);
      expect(find.text('Soğanı rendeleyin ve ekleyin.'), findsOneWidget);
      expect(find.text('Baharatları ekleyin ve köfte şekli verin.'), findsOneWidget);
      expect(find.text('Kızartın veya fırınlayın.'), findsOneWidget);
    });
  });
}
