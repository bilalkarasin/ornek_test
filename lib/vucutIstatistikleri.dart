import 'package:flutter/material.dart';

class BodyStatsPage extends StatelessWidget {
  final double currentWeight; // Şimdiki kilo
  final double targetWeight; // Hedef kilo
  final double bmi; // Vücut Kitle İndeksi

  BodyStatsPage({
    required this.currentWeight,
    required this.targetWeight,
    required this.bmi,
  });

  @override
  Widget build(BuildContext context) {
    // VKİ değerlendirmesi
    String bmiEvaluation;
    String recommendation; // BMI'ye göre öneri

    if (bmi < 18.5) {
      bmiEvaluation = "Zayıf";
      recommendation =
      "Kilonuz düşük seviyede. Dengeli bir beslenme planı uygulayarak kas ve yağ kütlenizi artırmanız önerilir. Bir diyetisyenle görüşebilirsiniz.";
    } else if (bmi >= 18.5 && bmi < 25) {
      bmiEvaluation = "Normal";
      recommendation =
      "Vücut kitle indeksiniz ideal aralıkta. Sağlıklı yaşam tarzınızı sürdürmek için düzenli egzersiz yapabilir ve dengeli beslenmeye devam edebilirsiniz.";
    } else {
      bmiEvaluation = "Fazla Kilolu";
      recommendation =
      "Fazla kilonuz var. Kalori alımınızı kontrol ederek düzenli egzersiz yapmanız önerilir. Kardiyo ve güç antrenmanları faydalı olacaktır.";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Vücut İstatistikleri',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Mevcut Kilo: $currentWeight kg",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Text(
              "Hedef Kilo: $targetWeight kg",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Text(
              "Vücut Kitle İndeksi: ${bmi.toStringAsFixed(1)}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: bmi < 18.5
                    ? Colors.orange[200]
                    : (bmi < 25 ? Colors.green[200] : Colors.red[200]),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: bmi < 18.5
                      ? Colors.orange
                      : (bmi < 25 ? Colors.green : Colors.red),
                  width: 2,
                ),
              ),
              child: Text(
                "Değerlendirme: $bmiEvaluation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: 10),
            Text(
              "Öneri:",
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 1.5,
                ),
              ),
              child: Text(
                recommendation,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
