import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({super.key});

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final List<String> imagePaths = List.generate(
    6,
    (index) => 'assets/carousel/index_$index.jpg',
  );

  int currentIndex = 0; // Track the current slide index

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final carouselHeight = (screenHeight) / 3;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: imagePaths.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Index number $index is clicked'),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePaths[index]),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: carouselHeight,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 16 / 9,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index; // Update current index on page change
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            imagePaths.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: currentIndex == index ? 12 : 8,
              width: currentIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? const Color.fromARGB(255, 211, 80, 234)
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
