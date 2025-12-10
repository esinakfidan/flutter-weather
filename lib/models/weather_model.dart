class WeatherModel {
  final String? gun;
  final String? ikon;
  final String? durum;
  final String? derece;
  final String? min;
  final String? max;
  final String? nem;

  WeatherModel(this.gun, this.ikon, this.durum, this.derece, this.min, this.max, this.nem);

  // Gelen JSON verisi senin API yapına göre uyarlandı
  WeatherModel.fromJson(Map<String, dynamic> json)
      : gun = json['date'], // Tarih (Örn: 2025-12-10)
        ikon = "https:${json['day']['condition']['icon']}",
        durum = json['day']['condition']['text'], // Hava durumu (Örn: Mist)
        derece = json['day']['avgtemp_c'].toString(), // Ortalama sıcaklık
        min = json['day']['mintemp_c'].toString(), // Min sıcaklık
        max = json['day']['maxtemp_c'].toString(), // Max sıcaklık
        nem = json['day']['avghumidity'].toString(); // Nem
}