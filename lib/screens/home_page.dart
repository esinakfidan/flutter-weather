import 'package:flutter/material.dart';
import 'package:pdroapp/models/weather_model.dart';
import 'package:pdroapp/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Servis sınıfını tanımlıyoruz
  final WeatherService _weatherService = WeatherService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hava Durumu"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WeatherModel>>(
        future: _weatherService.getWeatherData(), // Servis fonksiyonun
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Veri bulunamadı."));
          }

          final List<WeatherModel> weathers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: weathers.length,
            itemBuilder: (context, index) {
              final WeatherModel weather = weathers[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SOL TARA: Gün ve Durum
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // GÜN BİLGİSİ
                          Text(
                            weather.gun ?? "Gün", // Modelden 'gun' değişkenini çağırıyoruz
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          const SizedBox(height: 5),

                          // DURUM (Açık, Bulutlu vs.)
                          Text(
                            weather.durum?.toUpperCase() ?? "Durum", // Modelden 'durum' çağırıyoruz
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70
                            ),
                          ),
                        ],
                      ),

                      // ORTA: İkon (Resim url'si modelden geliyorsa)
                      if (weather.ikon != null)
                        Image.network(
                          weather.ikon!,
                          width: 40,
                          errorBuilder: (c, o, s) => const Icon(Icons.cloud, color: Colors.white),
                        ),

                      // SAĞ TARAF: Derece
                      Column(
                        children: [
                          Text(
                            "${weather.derece}°", // Modelden 'derece' çağırıyoruz
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                          Text(
                            "${weather.min}° / ${weather.max}°", // Modelden min/max
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}