import 'package:bmr_calculator/constants.dart';

// Kelas utama untuk menghitung BMR (Basal Metabolic Rate)
class BmrCalculator {
  BmrCalculator({
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.gender,
    this.bodyFatPercent,
    required this.formula,
  });

   // Variabel input utama
  final double heightCm; // Tinggi badan (cm)
  final double weightKg; // Berat badan (kg)
  final int age;
  final Gender gender;
  final double? bodyFatPercent; // Persentase lemak tubuh (opsional)
  final BmrFormula formula; // Rumus BMR yang digunakan


  double _bmr = 0.0; // Variabel internal untuk menyimpan hasil perhitungan BMR

  //menghitung nilai BMR berdasarkan formula yang dipilih
  double calculate() {
    switch (formula) {
      case BmrFormula.mifflinStJeor:
        // Rumus Mifflin-St Jeor
        _bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + (gender == Gender.male ? 5 : -161);
        break;
      case BmrFormula.revisedHarrisBenedict:
        // Rumus Harris-Benedict 
        if (gender == Gender.male) {
          _bmr = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
        } else {
          _bmr = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
        }
        break;
      case BmrFormula.katchMcArdle:
        // Rumus Katch-McArdle
        if (bodyFatPercent == null) {
          // fallback to Mifflin
          _bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + (gender == Gender.male ? 5 : -161);
        } else {
          final leanMass = weightKg * (1 - bodyFatPercent! / 100);
          _bmr = 370 + 21.6 * leanMass;
        }
        break;
    }
    return _bmr;
  }

  String bmrRounded() => calculate().round().toString(); // Mengembalikan nilai BMR dalam bentuk bulat (integer) sebagai string

  // Pengelompokan hasil BMR ke dalam kategori
  String getCategory() {
    final b = calculate();
    if (b < 1400) return 'Underweight';
    if (b <= 1800) return 'Normal';
    if (b <= 2200) return 'High';
    return 'Very High';
  }

  // interpretasi berdasarkan kategori BMR
  String getInterpretation() {
    final cat = getCategory();
    final val = bmrRounded();
    if (cat == 'Underweight') {
      return 'Nilai BMR Anda sebesar $val Calories/day termasuk rendah. Ini menandakan kebutuhan energi dasar yang lebih kecil dibandingkan rata-rata. Faktor penyebab bisa meliputi usia, massa otot rendah, atau pola makan kurang. Disarankan menambah asupan bergizi dan latihan kekuatan untuk meningkatkan massa otot secara bertahap.';
    } else if (cat == 'Normal') {
      return 'Nilai BMR Anda sebesar $val Calories/day termasuk normal. Ini menunjukkan metabolisme basal yang seimbang. Untuk mempertahankan berat badan, padu-padankan pola makan seimbang dengan aktivitas fisik harian sesuai tabel. Untuk menurunkan atau menaikkan berat badan, sesuaikan defisit/ surplus kalori berdasarkan tujuan.';
    } else if (cat == 'High') {
      return 'Nilai BMR Anda sebesar $val Calories/day tergolong tinggi. Hal ini kemungkinan disebabkan massa otot yang lebih besar atau faktor genetik. Pastikan asupan kalori sesuai tujuan (pemeliharaan, penurunan, atau peningkatan berat badan) dan perhatikan komposisi makronutrien.';
    } else {
      return 'Nilai BMR Anda sebesar $val Calories/day tergolong sangat tinggi. Perhatikan pola makan dan aktivitas untuk menjaga kesehatan metabolik. Konsultasi profesional dapat membantu menetapkan target nutrisi yang aman.';
    }
  }

  //untuk menghitung kebutuhan kalori harian
  static const Map<String, double> activityMultipliers = {
    'Sedentary (little or no exercise)': 1.2,
    'Light exercise 1-3 times/week': 1.375,
    'Moderate exercise 3-5 times/week': 1.55,
    'Very active 6-7 times/week': 1.725,
    'Extra active (physical job / very hard exercise)': 1.9,
  };

  //tabel kebutuhan kalori berdasarkan level aktivitas
  Map<String, int> caloriesForActivities() {
    final base = calculate();
    final Map<String, int> out = {};
    activityMultipliers.forEach((k, v) {
      out[k] = (base * v).round();
    });
    return out;
  }
}
