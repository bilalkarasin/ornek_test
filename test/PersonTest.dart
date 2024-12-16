import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/person.dart';

void main() {
  group('Person', () {
    test('should create a person with correct values', () {
      // Arrange
      final person = Person(
        ad: 'Bilal',
        soyad: 'Karaşin',
        yas: 23,
        boy: 170.0,
        kilo: 67.0,
        cinsiyet: 'Erkek',
      );

      // Assert
      expect(person.ad, 'Bilal');
      expect(person.soyad, 'Karaşin');
      expect(person.yas, 23);
      expect(person.boy, 170.0);
      expect(person.kilo, 67.0);
      expect(person.cinsiyet, 'Erkek');
    });

    test('should create a person from JSON', () {
      // Arrange
      final json = {
        'ad': 'Bilal',
        'soyad': 'Karaşin',
        'yas': 23,
        'boy': 170.0,
        'kilo': 67.0,
        'cinsiyet': 'Erkek',
      };

      // Act
      final person = Person.fromJson(json);

      // Assert
      expect(person.ad, 'Bilal');
      expect(person.soyad, 'Karaşin');
      expect(person.yas, 23);
      expect(person.boy, 170.0);
      expect(person.kilo, 67.0);
      expect(person.cinsiyet, 'Erkek');
    });

    test('should convert person to JSON', () {
      // Arrange
      final person = Person(
        ad: 'Bilal',
        soyad: 'Karaşin',
        yas: 23,
        boy: 170.0,
        kilo: 67.0,
        cinsiyet: 'Erkek',
      );

      // Act
      final json = person.toJson();

      // Assert
      expect(json['ad'], 'Bilal');
      expect(json['soyad'], 'Karaşin');
      expect(json['yas'], 23);
      expect(json['boy'], 170.0);
      expect(json['kilo'], 67.0);
      expect(json['cinsiyet'], 'Erkek');
    });
  });
}
