import 'package:flutter/material.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';

import 'DatabaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Databasehelper.instance.initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Alt menüde seçili olan sekmeyi takip etmek için
  double _currentWaterIntake = 0; // Tüketilen su miktarı
  double _currentExerciseValue = 0; // Egzersiz değeri

  @override
  void initState() {
    super.initState();
    PersonService.createPerson(Person(ad: "Bilal", soyad: "Karaşin", boy: 170, kilo: 67, yas: 23, cinsiyet: "erkek"));
    PersonService.createPerson(Person(ad: "Ali", soyad: "Veli", boy: 180, kilo: 77, yas: 24, cinsiyet: "erkek"));
    PersonService.createPerson(Person(ad: "Şerife", soyad: "Topçuoğlu", boy: 175, kilo: 66, yas: 21, cinsiyet: "kadın"));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildAnasayfa(), // Anasayfa içeriği
      Center(child: Text("Kilo Takibi", style: TextStyle(fontSize: 24))),
      FoodRecipesPage(), // Yemek Tarifleri Sayfası
      Center(child: Text("İlerleme Grafiği", style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), // Menü simgesi
          onPressed: () {
            _showOptions(context); // Seçenekler için Bottom Sheet açılır
          },
        ),
        title: Text(
          "Bilal",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: false, // Başlık sola hizalı
      ),
      body: _pages[_currentIndex], // Alt menüye göre değişen ekran
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Seçili olan sekmeyi gösterir
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Tıklanan sekmeye geçiş yap
          });
        },
        type: BottomNavigationBarType.fixed, // 4+ sekme için sabit tip
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularIndicator(title: "Alınan", unit: "KCAL", value: _currentExerciseValue / 2000),
              CircularIndicator(title: "Yakılan", unit: "KCAL", value: _currentExerciseValue / 2000),
            ],
          ),
          SizedBox(height: 20),
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
    showDialog(
      context: context,
      builder: (context) {
        String selectedExercise = 'Basketbol';
        double exerciseCalories = 0;

        Map<String, double> exerciseCaloriesMap = {
          'Basketbol': 300,
          'Yüzme': 400,
          'Koşmak': 350,
          'Futbol Oynamak': 450,
          'Ağırlık Kaldırmak': 500,
        };

        return AlertDialog(
          title: Text("Egzersiz Ekle"),
          content: DropdownButton<String>(
            value: selectedExercise,
            onChanged: (String? newValue) {
              setState(() {
                selectedExercise = newValue!;
                exerciseCalories = exerciseCaloriesMap[selectedExercise]!;
              });
            },
            items: exerciseCaloriesMap.keys.map((String exercise) {
              return DropdownMenuItem<String>(
                value: exercise,
                child: Text(exercise),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentExerciseValue += exerciseCalories;
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => BodyStatsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Kaydedilen Yemek Listeleri"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodListsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Bildirimler"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            /*ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text("Yemek Tarifleri"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodRecipesPage()));
              },
            ),*/
          ],
        );
      },
    );
  }
}

// Yemek Tarifleri Sayfası
// Yemek Tarifleri Sayfası
class FoodRecipesPage extends StatefulWidget {
  @override
  _FoodRecipesPageState createState() => _FoodRecipesPageState();
}

class _FoodRecipesPageState extends State<FoodRecipesPage> {
  List<String> recipes = [
    'Köfte',
    'Makarna',
    'Salata',
    'Çorba',
    'Pilav',
    'Izgara Balık',
  ];
  List<bool> isFavorited = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Yemek Tarifleri', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  title: Text(
                    recipes[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorited[index] ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited[index] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorited[index] = !isFavorited[index];
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodRecipeDetailPage(
                          recipeName: recipes[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Yemek Tarifi Detay Sayfası
class FoodRecipeDetailPage extends StatelessWidget {
  final String recipeName;

  FoodRecipeDetailPage({required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(recipeName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Malzemeler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Maviyle uyumlu renk
                ),
              ),
              SizedBox(height: 8.0),
              _buildIngredientsList(),
              SizedBox(height: 16.0),
              Text(
                'Yapılışı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Maviyle uyumlu renk
                ),
              ),
              SizedBox(height: 8.0),
              _buildRecipeSteps(),
            ],
          ),
        ),
      ),
    );
  }

  // Yemek malzemelerini listeleyen widget
  Widget _buildIngredientsList() {
    return Column(
      children: [
        _ingredientTile('Malzeme 1'),
        _ingredientTile('Malzeme 2'),
        _ingredientTile('Malzeme 3'),
      ],
    );
  }

  // Her malzeme için ListTile oluşturan widget
  Widget _ingredientTile(String ingredient) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(ingredient),
    );
  }

  // Yemek yapılışını listeleyen widget
  Widget _buildRecipeSteps() {
    return Column(
      children: [
        _recipeStepTile('Adım 1', 'Açıklama 1'),
        _recipeStepTile('Adım 2', 'Açıklama 2'),
        _recipeStepTile('Adım 3', 'Açıklama 3'),
      ],
    );
  }

  // Her adım için ListTile oluşturan widget
  Widget _recipeStepTile(String step, String description) {
    return ListTile(
      leading: Text(step, style: TextStyle(fontWeight: FontWeight.bold)),
      title: Text(description),
    );
  }
}



// Vücut İstatistikleri Sayfası
class BodyStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vücut İstatistikleri")),
      body: Center(child: Text("Vücut İstatistikleri Ekranı")),
    );
  }
}

// Kaydedilen Yemek Listeleri
class FoodListsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yemek Listeleri")),
      body: Center(child: Text("Yemek Listeleri Ekranı")),
    );
  }
}

// Bildirimler Sayfası
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bildirimler")),
      body: Center(child: Text("Bildirimler Ekranı")),
    );
  }
}

// Ayarlar Sayfası
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ayarlar")),
      body: Center(child: Text("Ayarlar Ekranı")),
    );
  }
}

// Daire İndikatör Widget
class CircularIndicator extends StatelessWidget {
  final String title;
  final String unit;
  final double value;

  CircularIndicator({required this.title, required this.unit, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: value, strokeWidth: 8),
            Text("${(value * 100).toInt()}%", style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
        Text("$title\n$unit", textAlign: TextAlign.center),
      ],
    );
  }
}
