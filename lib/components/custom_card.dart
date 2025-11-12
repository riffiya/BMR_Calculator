import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.color, this.child, this.onTap});
  final Color color; // Warna latar belakang kartu
  final Widget? child; // Konten di dalam kartu
  final VoidCallback? onTap; // Aksi saat kartu ditekan (opsional)

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12.0), // Jarak luar antar kartu
        padding: const EdgeInsets.all(12.0), // Jarak dalam isi kartu
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8.0)),
        child: child,
      ),
    );
  }
}
