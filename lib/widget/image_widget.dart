import 'package:flutter/material.dart';
import 'package:tubes_movietrailer_app/app_constants.dart';

enum TypeSrcImg { movieDb, external }

class ImageNetworkWidget extends StatelessWidget {
  const ImageNetworkWidget({
    Key? key,
    this.imageSrc,
    this.type = TypeSrcImg.movieDb,
    this.height,
    this.width,
    this.onTap,
    this.radius = 0.0,
  }) : super(key: key);

  final String? imageSrc;
  final TypeSrcImg type;
  final double? height;
  final double? width;
  final double radius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.network(
            //karena imagenya Stack, kita atur heightnya juga
            height: height,
            width: width,
            //Image.network butuh src, src nya bisa dari poster/backdropnya
            //jadi kita panggil imageSrc nya
            type == TypeSrcImg.movieDb
                ? '${AppConstants.imageUrlW500}$imageSrc'
                : imageSrc!,
            //gambarnya akan mengikuti tinggi dari Carousel Slider dibawah yang height
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              return Container(
                height: height,
                width: width,
                color: Colors.black26,
                child: child,
              );
            },
            //error builder ditampilkan ketika backdropnya null/gambar gagal diambil
            //bungkus menggunakan block body
            errorBuilder: (_, __, ___) {
              return SizedBox(
                //containernya juga kita atur heightnya
                height: height,
                width: width,
                child: const Icon(Icons.broken_image_rounded),
              );
            },
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
