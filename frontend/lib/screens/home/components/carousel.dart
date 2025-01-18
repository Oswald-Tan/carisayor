import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoriesCarousel extends StatefulWidget {
  const CategoriesCarousel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesCarouselState createState() => _CategoriesCarouselState();
}

class _CategoriesCarouselState extends State<CategoriesCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "image": "assets/images/slide-1.jpg",
      },
      {
        "image": "assets/images/slide-2.jpg",
      },
      {
        "image": "assets/images/slide-3.jpg",
      },
      {
        "image": "assets/images/slide-4.jpg",
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        height: 330,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F1F5),
        ),
        child: Column(
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 225.0, // Set carousel height as needed
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: MediaQuery.of(context).size.width / 225.0,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemCount: categories.length,
              itemBuilder: (context, index, realIndex) {
                return SizedBox(
                  height: 225.0,
                  child: CategoryCard(
                    image: categories[index]["image"],
                    imageHeight: 200.0,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                categories.length,
                (index) => Container(
                  width: 6.0,
                  height: 6.0,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? const Color(0xFF74B11A)
                        : const Color(0xFFC5EF86),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.image,
    required this.imageHeight,
  });

  final String image;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            image,
            width: double.infinity,
            height: imageHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
