//kita butuh Container ini agar nantinya gambar yang diluar bisa di rounded.
import 'package:flutter/material.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_detail_model.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';

import 'image_widget.dart';

class ItemMovieWidget extends StatelessWidget {
  final MovieModel? movie;
  final MovieDetailModel? movieDetail;
  final double heightBackdrop;
  final double widthBackdrop;
  final double heightPoster;
  final double widthPoster;
  final double radius;
  final void Function()? onTap;

  const ItemMovieWidget({
    Key? key,
    required this.heightBackdrop,
    required this.widthBackdrop,
    required this.heightPoster,
    required this.widthPoster,
    this.radius = 12,
    this.movie,
    this.movieDetail,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gambar backdrop
        ImageNetworkWidget(
          height: heightBackdrop,
          width: widthBackdrop,
          imageSrc:
              '${movieDetail != null ? movieDetail!.backdropPath : movie?.backdropPath ?? ''}',
        ),
        // Gradient overlay
        Container(
          height: heightBackdrop,
          width: widthBackdrop,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ),
          ),
        ),
        // Konten title dan poster
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar poster
              ImageNetworkWidget(
                height: heightPoster,
                width: widthPoster,
                radius: radius,
                imageSrc:
                    '${movieDetail != null ? movieDetail!.posterPath : movie?.posterPath ?? ''}',
              ),
              const SizedBox(height: 8),
              // Judul
              Text(
                movieDetail != null ? movieDetail!.title : movie?.title ?? '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Rating dan vote count
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber),
                  Text(
                    '${movieDetail != null ? movieDetail!.voteAverage : movie?.voteAverage ?? 0.0} '
                    '(${movieDetail != null ? movieDetail!.voteCount : movie?.voteCount ?? 0})',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Area klik
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ),
      ],
    );
  }
}
