class Person {
  int? id;
  String? ad;
  String? soyad;
  int? boy;
  int? kilo;
  int? yas;
  String? cinsiyet;

  Person({
      this.id,
      required this.ad,
      required this.soyad,
      required this.boy,
      required this.kilo,
      required this.yas,
      required this.cinsiyet});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    soyad = json['soyad'];
    boy = json['boy'];
    kilo = json['kilo'];
    yas = json['yas'];
    cinsiyet = json['cinsiyet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ad'] = ad;
    data['soyad'] = soyad;
    data['boy'] = boy;
    data['kilo'] = kilo;
    data['yas'] = yas;
    data['cinsiyet'] = cinsiyet;
    return data;
  }
}