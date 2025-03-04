import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProdukCard extends StatelessWidget {
  const ShimmerProdukCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Menambahkan border radius
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 200,
          height: 275,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F1F5),
            borderRadius: BorderRadius.circular(10), // Border radius utama
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 140,
                color: Colors.grey[300],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 60,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            height: 12,
                            color: Colors.grey[300],
                          ),
                          Container(
                            width: 40,
                            height: 16,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
