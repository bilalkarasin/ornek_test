import 'package:flutter/material.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';
import 'package:ornek_test/vucutIstatistikleri.dart';
import 'package:ornek_test/yemekTarifi.dart';
import 'DatabaseHelper.dart';
import 'ayarlar.dart';
import 'kiloTakibi.dart';
import 'ilerlemeGrafigi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Databasehelper.instance.initDb();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false; // Temanın başlangıç durumu

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme; // Temayı değiştir
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(), // Temayı burada ayarlıyoruz
      home: HomePage(toggleTheme: _toggleTheme), // Ana sayfaya fonksiyonu geçiriyoruz
    );
  }
}

class HomePage extends StatefulWidget {
  final Function toggleTheme;

  HomePage({required this.toggleTheme});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Alt menüde seçili olan sekmeyi takip etmek için
  double _currentWaterIntake = 0; // Tüketilen su miktarı
  double _currentExerciseValue = 0; // Egzersiz değeri
  double _currentWeight = 67; // Varsayılan başlangıç kilosu
  double _targetWeight = 65; // Varsayılan hedef kilo

  @override
  void initState() {
    super.initState();
    //PersonService.createPerson(Person(ad: "Bilal", soyad: "Karaşin", boy: 170, kilo: 67, yas: 23, cinsiyet: "Erkek"));
  }

  // Kilo güncelleme diyalogu
  void _showUpdateWeightDialog(BuildContext context) {
    double newWeight = _currentWeight; // Varsayılan değer mevcut kilo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kilo Güncelle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Yeni Kilo (kg)"),
            onChanged: (value) {
              newWeight = double.tryParse(value) ?? _currentWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentWeight = newWeight; // Yeni kiloyu güncelle
                });
                PersonService.updateWeight("Bilal", newWeight); // Backend güncellemesi
                Navigator.pop(context);
              },
              child: Text("Güncelle"),
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

  // Hedef kilo belirleme diyalogu
  void _showSetTargetWeightDialog(BuildContext context) {
    double newTargetWeight = _targetWeight; // Varsayılan hedef kilo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hedef Kilo Belirle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Hedef Kilo (kg)"),
            onChanged: (value) {
              newTargetWeight = double.tryParse(value) ?? _targetWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _targetWeight = newTargetWeight; // Yeni hedef kiloyu güncelle
                });
                Navigator.pop(context);
              },
              child: Text("Belirle"),
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildAnasayfa(),
      KiloTakibiPage(initialWeight: _currentWeight),
      FoodRecipesPage(),
      ProgressPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _showOptions(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bilal Karaşin",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Boy = 170 cm, Kilo = $_currentWeight, Yaş = 23, Cinsiyet = Erkek",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Kilo Takibi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Yemek Tarifleri",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "İlerleme Grafiği",
          ),
        ],
      ),
    );
  }

  // Anasayfa İçeriği
  Widget _buildAnasayfa() {
    double exerciseProgress = _currentExerciseValue / 1000; // Örneğin 1000 kcal hedefi
    double progressPercentage = (exerciseProgress * 100).clamp(0, 100); // Yüzde değeri

    // VKI hesaplama
    double heightInMeters = 1.70; // Boy 170 cm
    double bmi = _currentWeight / (heightInMeters * heightInMeters); // VKİ formülü

    // VKİ değerlendirmesi
    String bmiEvaluation;
    if (bmi < 18.5) {
      bmiEvaluation = "Zayıf";
    } else if (bmi >= 18.5 && bmi < 25) {
      bmiEvaluation = "Normal";
    } else {
      bmiEvaluation = "Fazla Kilolu";
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: exerciseProgress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                ),
                if (progressPercentage == 100)
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40,
                  )
                else
                  Text(
                    "${progressPercentage.toStringAsFixed(0)}%",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              "Yakılan Kalori: $_currentExerciseValue kcal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Tüketilen Su",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(value: _currentWaterIntake / 2738),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_currentWaterIntake.toStringAsFixed(0)}/2738 ml"),
              if (_currentWaterIntake >= 2738)
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                ),
              ElevatedButton(
                onPressed: () => _showAddWaterDialog(context),
                child: Text("Ekle"),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Egzersizler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddExerciseDialog(context),
            child: Text("Egzersiz Ekle"),
          ),
          SizedBox(height: 20),
          Divider(thickness: 3, color: Colors.blueAccent),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showUpdateWeightDialog(context),
                  child: Text("Kilo Güncelle"),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showSetTargetWeightDialog(context),
                  child: Text("Hedef Kilo Ayarla"),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Hedef Kilo: $_targetWeight kg",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          SizedBox(height: 30),
          Spacer(),
        ],
      ),
    );
  }

  // Su eklemek için diyalog
  void _showAddWaterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double waterAmount = 0;
        return AlertDialog(
          title: Text("Su Ekle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Miktar (ml)"),
            onChanged: (value) {
              waterAmount = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentWaterIntake += waterAmount;
                });
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

  // Egzersiz eklemek için diyalog
  void _showAddExerciseDialog(BuildContext context) {
    String selectedExercise = 'Basketbol';
    double selectedExerciseCalories = 300;

    Map<String, double> exerciseCaloriesMap = {
      'Basketbol': 300,
      'Yüzme': 400,
      'Koşmak': 350,
      'Futbol Oynamak': 450,
      'Ağırlık Kaldırmak': 500,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Egzersiz Ekle"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedExercise,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExercise = newValue!;
                        selectedExerciseCalories = exerciseCaloriesMap[selectedExercise]!;
                      });
                    },
                    items: exerciseCaloriesMap.keys.map((String exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise,
                        child: Text(exercise),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Seçilen Egzersiz: $selectedExercise",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Kalori Değeri: $selectedExerciseCalories",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentExerciseValue += selectedExerciseCalories;
                });
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

  // Seçenekler Menüsü
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Vücut İstatistikleri"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BodyStatsPage(
                      currentWeight: _currentWeight,
                      targetWeight: _targetWeight,
                      bmi: _currentWeight / (1.70 * 1.70), // VKİ hesaplama
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(toggleTheme: widget.toggleTheme)));
              },
            ),
          ],
        );
      },
    );
  }
}

// Ayarlar Sayfası Sınıfı
class SettingsPage extends StatelessWidget {
  final Function toggleTheme;

  SettingsPage({required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SwitchListTile(
          title: Text('Karanlık Tema'),
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (value) {
            toggleTheme(); // Tema değiştirme fonksiyonunu çağır
          },
          secondary: Icon(
            Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
          ),
        ),
      ),
    );
  }
}
