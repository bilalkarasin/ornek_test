//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu


import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/DatabaseHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  group('Databasehelper Tests', () {
    late Databasehelper dbHelper;

    setUp(() async {
      // Test için Databasehelper'ı başlat
      dbHelper = Databasehelper.instance;
      await dbHelper.initDb();

      // Her testten önce tabloyu temizle
      final database = await dbHelper.db;
      await database.delete('person');
    });

    tearDown(() async {
      // Testten sonra veritabanını kapat
      Databasehelper.close();
    });

    test('Veri ekleme testi', () async {
      final person = {
        'ad': 'Ali',
        'soyad': 'Veli',
        'boy': 180,
        'kilo': 75.5,
        'yas': 25,
        'cinsiyet': 'Erkek',
      };

      int id = await Databasehelper.insert('person', person);
      expect(id, isNonZero);

      final results = await Databasehelper.query('person');
      expect(results.length, 1);
      expect(results.first['ad'], 'Ali');
    });

    test('Veri güncelleme testi', () async {
      final person = {
        'ad': 'Ali',
        'soyad': 'Veli',
        'boy': 180,
        'kilo': 75.5,
        'yas': 25,
        'cinsiyet': 'Erkek',
      };

      int id = await Databasehelper.insert('person', person);

      final updatedPerson = {
        'ad': 'Ahmet',
        'soyad': 'Demir',
        'boy': 175,
        'kilo': 70.0,
        'yas': 30,
        'cinsiyet': 'Erkek',
      };

      int rowsAffected = await Databasehelper.update(
        'person',
        updatedPerson,
        where: 'id = ?',
        whereArgs: [id],
      );
      expect(rowsAffected, 1);

      final results = await Databasehelper.query('person');
      expect(results.first['ad'], 'Ahmet');
      expect(results.first['soyad'], 'Demir');
    });

    test('Veri silme testi', () async {
      final person = {
        'ad': 'Ali',
        'soyad': 'Veli',
        'boy': 180,
        'kilo': 75.5,
        'yas': 25,
        'cinsiyet': 'Erkek',
      };

      int id = await Databasehelper.insert('person', person);

      int rowsDeleted = await Databasehelper.delete(
        'person',
        where: 'id = ?',
        whereArgs: [id],
      );
      expect(rowsDeleted, 1);

      final results = await Databasehelper.query('person');
      expect(results.length, 0);
    });

    test('Tablodaki tüm verileri sorgulama testi', () async {
      final person1 = {
        'ad': 'Ali',
        'soyad': 'Veli',
        'boy': 180,
        'kilo': 75.5,
        'yas': 25,
        'cinsiyet': 'Erkek',
      };

      final person2 = {
        'ad': 'Ayşe',
        'soyad': 'Yılmaz',
        'boy': 165,
        'kilo': 60.0,
        'yas': 28,
        'cinsiyet': 'Kadın',
      };

      await Databasehelper.insert('person', person1);
      await Databasehelper.insert('person', person2);

      final results = await Databasehelper.query('person');
      expect(results.length, 2);
    });
  });
}
