import 'package:flutter/material.dart';
import 'package:ornek_test/personService.dart';

class KiloTakibiPage extends StatefulWidget {
  final double initialWeight; // İlk girilen kilo

  // Constructor ile gelen verileri alıyoruz
  KiloTakibiPage({
    required this.initialWeight,
  });

  @override
  _KiloTakibiPageState createState() => _KiloTakibiPageState();
}

class _KiloTakibiPageState extends State<KiloTakibiPage> {
  double _currentWeight = 0.0; // Başlangıç değeri 0.0
  List<Map<String, dynamic>> _weightRecords = [];

  @override
  void initState() {
    super.initState();
    // Başlangıç verilerini ekleyelim
    _currentWeight = widget.initialWeight;
    _weightRecords = [
      {'date': '2024-12-01', 'weight': _currentWeight},
    ];
  }

  void _showAddWeightDialog(BuildContext context) {
    double newWeight = _currentWeight; // Başlangıç değeri mevcut kilo

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kilo Ekle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Kilo (kg)"),
            onChanged: (value) {
              newWeight = double.tryParse(value) ?? newWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Yeni kilo kaydını listeye ekliyoruz
                  _weightRecords.add({
                    'date': DateTime.now().toString().split(' ')[0],
                    'weight': newWeight,
                  });
                  _currentWeight = newWeight; // Mevcut kilo güncelleniyor
                });
                PersonService.updateWeight("Bilal", newWeight); // Backend güncellemesi
                Navigator.pop(context);
              },
              child: Text("Ekle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }



  void _deleteWeightRecord(int index) {
    setState(() {
      _weightRecords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kilo Takibi",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.deepOrange, // Deep Orange background
        centerTitle: true,  // Başlığı ortalar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Mevcut Kilo: ${_currentWeight} kg", // currentWeight burada gösteriliyor
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20),

            // "Yeni Kilo Kaydı Ekle" butonunu ortaladık
            Center(
              child: ElevatedButton(
                onPressed: () => _showAddWeightDialog(context),
                child: Text("Yeni Kilo Kaydı Ekle"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 22, horizontal: 36),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Kilo Geçmişi",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _weightRecords.length,
                itemBuilder: (context, index) {
                  final record = _weightRecords[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text("Tarih: ${record['date']}"),
                      subtitle: Text("Kilo: ${record['weight']} kg"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteWeightRecord(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
