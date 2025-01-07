//Yazan:Bilal Karaşin,Şerife Topçuoğlu
//Test eden:Bilal Karaşin,Şerife Topçuoğlu
//Hata ayıklayan:Bilal Karaşin,Şerife Topçuoğlu

import 'package:flutter_test/flutter_test.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';

void main() {
  test('Yeni kişi oluşturma', () {
    // Arrange
    final person = Person(ad: 'Bilal', soyad: 'Karaşin', boy: 170, kilo: 67, yas: 23, cinsiyet: 'Erkek');

    // Act
    PersonService.createPerson(person);

    // Assert
    expect(PersonService.persons.length, equals(1));
    expect(PersonService.persons.first.ad, equals('Bilal'));
  });

  test('Kilo güncelleme', () async {
    // Arrange
    final person = Person(ad: 'Bilal', soyad: 'Karaşin', boy: 170, kilo: 67, yas: 23, cinsiyet: 'Erkek');
    PersonService.createPerson(person);

    // Act
    final updateSuccess = await PersonService.updateWeight('Bilal', 70.0);

    // Assert
    expect(updateSuccess, isTrue);
    expect(PersonService.persons.first.kilo, equals(70.0));
  });
}
