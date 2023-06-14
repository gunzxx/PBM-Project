import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../components/back_button.dart';

class FullscreenImageScreen extends StatelessWidget {
  final List<dynamic> imageUrls;
  final int currentIndex;

  const FullscreenImageScreen(
      {super.key, required this.imageUrls, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: PhotoViewGallery.builder(
              itemCount: imageUrls.length,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(imageUrls[index]),
                  initialScale: PhotoViewComputedScale.contained,
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              pageController: PageController(initialPage: currentIndex),
              enableRotation: true,
              loadingBuilder: (context, event) {
                return Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {},
            ),
          ),
          tombolKembali(context),
        ],
      ),
    );
  }
}
