import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({super.key, required this.icon, required this.onPressed});
  final IconData icon; // Ikon yang ditampilkan di dalam tombol
  final VoidCallback onPressed; // Aksi yang dijalankan saat tombol ditekan

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40), // Ukuran tetap
      shape: const CircleBorder(), // Bentuk lingkaran
      fillColor: Colors.white, // Warna latar tombol
      elevation: 0,
      child: Icon(icon, size: 16, color: Colors.black87), // Tampilkan ikon
    );
  }
}
