import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../mylib/color.dart';

class FullscreenImageScreen extends StatelessWidget {
  final List<dynamic> imageUrls;
  final int currentIndex;

  const FullscreenImageScreen(
      {super.key, required this.imageUrls, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: bl1),
      body: Container(
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
          onPageChanged: (int index) {},
        ),
      ),
    );
  }
}
