import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/main.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_detail_page.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_top_rated_provider.dart';
import 'package:tubes_movietrailer_app/widget/image_widget.dart';

class MovieTopRatedComponent extends StatefulWidget {
  const MovieTopRatedComponent({Key? key}) : super(key: key);

  @override
  _MovieTopRatedComponentState createState() => _MovieTopRatedComponentState();
}

class _MovieTopRatedComponentState extends State<MovieTopRatedComponent> {
  @override
  void initState() {
    //panggil WidgetsBinding.instance.addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //panggil context
      //tipe providernya MovieGetPopularProvider
      context.read<MovieGetTopRatedProvider>().getTopRated(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //untuk ini, kita copy SliverToBoxAdapter yang ada di movie_page.dart
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        //childnya pake Consumer yang mendengar MovieGetPopularProvider yang ada di main.dart
        //supaya mendapat data dari popularnya.
        child: Consumer<MovieGetTopRatedProvider>(
          builder: (_, provider, __) {
            //periksa
            if (provider.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12.0)),
              );
            }

            if (provider.movies.isNotEmpty) {
              return ListView.separated(
                  //tambahkan padding
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  //tamabahkan scrollDirection agar menyamping
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    //karena hanya menampilkan image, kita panggil aja widget image_widget.dart
                    //karena imageSrc nya boleh kosong, kita ubah di image_widget.dart
                    return ImageNetworkWidget(
                      imageSrc: provider.movies[index].posterPath,
                      height: 200,
                      width: 120,
                      radius: 12.0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return MovieDetailPage(
                                  id: provider.movies[index].id);
                            },
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(
                        width: 8.0,
                      ),
                  itemCount: provider.movies.length);
            }

            //kalo dia gagal,
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12.0)),
              child: const Center(child: Text('Not Found Top Rated Movies')),
            );
          },
        ),
      ),
    );
  }
}
