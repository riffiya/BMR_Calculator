import 'package:flutter/material.dart';
import 'package:bmr_calculator/constants.dart';

/// Widget tombol bawah untuk aksi utama (misalnya "CALCULATE").
class BottomButton extends StatelessWidget {
  const BottomButton({super.key, required this.title, required this.onTap});

  final String title; // Teks di tombol
  final VoidCallback onTap; // Aksi saat tombol ditekan

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Jalankan aksi ketika tombol ditekan
      child: Container(
        height: bottomContainerHeight, // Tinggi tombol
        decoration: BoxDecoration(
          color: primaryBlue, // Warna tombol
          borderRadius: BorderRadius.circular(8), // Sudut melengkung
        ),
        child: Center(
          child: Text(title, style: buttonTextStyle), // Teks di tengah tombol
        ),
      ),
    );
  }
}
