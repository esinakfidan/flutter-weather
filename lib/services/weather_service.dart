import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:pdroapp/models/weather_model.dart';

class WeatherService {
  Future<String> _getLocation() async {
    // 1. Konum servisi açık mı?
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Hata döndürüp çıkıyoruz (return ekledik)
      return Future.error("Konum servisiniz kapalı");
    }

    // 2. İzin kontrolü
    LocationPermission permission = await Geolocator
        .checkPermission(); // Yazım hatası düzeltildi
    if (permission == LocationPermission.denied) {
      // İzin yoksa iste
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Hâlâ vermediyse hata döndür
        return Future.error("Konum izni vermelisiniz");
      }
    }

    // Eğer kalıcı olarak reddettiyse (Ayarlardan açması gerekir)
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Konum izni kalıcı olarak reddedildi, ayarlardan açmalısınız.");
    }

    // 3. Pozisyonu al
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // 4. Koordinattan şehir ismini bul (Geocoding)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // İlk sonucu alıp şehri çekiyoruz
    // Bazen locality null gelebilir, o yüzden administrativeArea da yedek olabilir
    String? city = placemarks [0].administrativeArea;

    if (city == null) {
      return Future.error("Şehir bulunamadı");
    }

    return city;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    //  (Şehri) buluyoruz
    final String city = await _getLocation();
    final String apiKey = "e79ea37fba1d4494a5072708251012";

    // q=Balikesir yerine q=$city yazdık. Böylece şehir otomatik değişecek.
    final String url =
        "https://api.weatherapi.com/v1/forecast.json?key=e79ea37fba1d4494a5072708251012&q=Balikesir&days=10&aqi=no&alerts=no";

    print("İstek atılıyor: $city için...");

    try {
      final response = await Dio().get(url);

      print("GELEN JSON VERİSİ: ${response.data}");

      if (response.statusCode == 200) {
        final List list = response.data['forecast']['forecastday'];

        final List <WeatherModel> weatherList =
        list.map((e) => WeatherModel.fromJson(e)).toList();

        return weatherList;
      } else {
        print("istek başarısız:${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("hata oluştu: $e");
      return [];
    }
  }

}