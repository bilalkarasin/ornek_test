import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false; // Temanın başlangıç durumu

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme; // Temayı değiştir
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Ayarlar',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        color: _isDarkTheme ? Colors.black : Colors.white, // Arka plan rengi
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalamayı ekledik
            children: [
              // Karanlık tema butonunu en başa taşıdık
              SwitchListTile(
                title: Text(
                  'Karanlık Tema',
                  style: TextStyle(
                    color: _isDarkTheme ? Colors.white : Colors.black87,
                  ),
                ),
                value: _isDarkTheme,
                onChanged: (value) {
                  _toggleTheme();
                },
                secondary: Icon(
                  _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                  color: _isDarkTheme ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 20), // Buton ile içerik arasında boşluk ekledik

              // "Ayarlar Burada Görüntülenecek." metni
              /*Text(
                'Ayarlar Burada Görüntülenecek.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isDarkTheme ? Colors.white : Colors.black87,
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
