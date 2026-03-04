import 'dart:ui';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> images;
  final String heroTag;

  final RxInt selectedIndex = 0.obs;

  ProductImageGallery({super.key, required this.images,  required this.heroTag});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: 350,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F5F0),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return Hero(
      tag: heroTag,
      child: Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F5F0),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child:CldImageWidget(
                    publicId: images[selectedIndex.value],
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),
            ),

            _buildThumb(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumb() {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: List.generate(images.length, (index) {
                      return Obx(() {
                        bool isSelected = selectedIndex.value == index;
                        return GestureDetector(
                          onTap: () => selectedIndex.value = index,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 61,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CldImageWidget(
                                publicId: images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      });
                    }),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12.0),

          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(images.length, (index) {
                bool isSelected = selectedIndex.value == index;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isSelected ? 12.0 : 6.0,
                  height: 6.0,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99.0),

                    color: isSelected ? Colors.black87 : Colors.black26,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
