import 'package:flutter/material.dart';
import 'package:bmr_calculator/components/custom_card.dart';
import 'package:bmr_calculator/constants.dart';

// Halaman untuk menampilkan hasil perhitungan BMR
class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.bmr,
    required this.category,
    required this.interpretation,
    required this.caloriesTable,
  });

  // Data yang dikirim dari halaman Input
  final int bmr; // Nilai BMR akhir
  final String category; // Kategori hasil (misal: Normal, Rendah, Tinggi)
  final String interpretation; // Penjelasan atau saran tambahan
  final Map<String, int> caloriesTable; // Tabel kalori per level aktivitas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMR RESULT')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // === Bagian hasil utama ===
            CustomCard(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(category.toUpperCase(), style: resultCategoryStyle),
                    const SizedBox(height: 6),
                    Text('$bmr', style: bmrNumberStyle),
                    const Text('Calories/day', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 18),

                    // Teks penjelasan hasil
                    Text(
                      'Nilai BMR Anda sebesar $bmr kalori per hari. '
                      'Angka ini menunjukkan jumlah energi yang dibutuhkan tubuh Anda saat istirahat penuh.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Judul tabel
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Kebutuhan kalori berdasarkan tingkat aktivitas:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // === Tabel kalori ===
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          Colors.blue.shade50,
                        ),
                        columnSpacing: 20,
                        dataRowMinHeight: 32,
                        dataRowMaxHeight: 40,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Activity Level',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Calories',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                        rows: caloriesTable.entries.map((e) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    e.key,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  e.value.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // === Interpretasi dan Catatan ===
                    Text(
                      interpretation,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Catatan praktis:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '- Untuk menjaga berat badan: konsumsi kalori sesuai level aktivitas Anda pada tabel.\n'
                      '- Untuk menurunkan berat badan: buat defisit kalori moderat (300–500 kcal/hari).\n'
                      '- Untuk menambah massa otot: tambah 200–400 kcal/hari disertai latihan beban.\n'
                      'Jika memiliki kondisi medis atau tujuan khusus, konsultasikan dengan profesional gizi atau dokter.',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 13.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tombol hitung ulang
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: bottomContainerHeight,
                decoration: BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('RE-CALCULATE', style: buttonTextStyle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
