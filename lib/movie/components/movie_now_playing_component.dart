import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_detail_page.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_now_playing_provider.dart';
import 'package:tubes_movietrailer_app/widget/image_widget.dart';

class MovieNowPlayingComponent extends StatefulWidget {
  const MovieNowPlayingComponent({Key? key}) : super(key: key);

  @override
  _MovieNowPlayingComponentState createState() =>
      _MovieNowPlayingComponentState();
}

class _MovieNowPlayingComponentState extends State<MovieNowPlayingComponent> {
  //panggil fungsi initState()
  @override
  void initState() {
    //panggil WidgetBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //panggil context
      //tipe providernya MovieGetPopularProvider
      context.read<MovieGetNowPlayingProvider>().getNowPlaying(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        //childnya pake Consumer yang mendengar MovieGetPopularProvider yang ada di main.dart
        //supaya mendapat data dari popularnya.
        child: Consumer<MovieGetNowPlayingProvider>(
          builder: (_, provider, __) {
            //periksa
            if (provider.isLoading) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              );
            }

            if (provider.movies.isNotEmpty) {
              return ListView.separated(
                  //tambahkan padding
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  //tamabahkan scrollDirection agar menyamping
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final movie = provider.movies[index];
                    //karena hanya menampilkan image, kita panggil aja widget image_widget.dart
                    //karena imageSrc nya boleh kosong, kita ubah di image_widget.dart
                    return Stack(
                      children: [
                        ImageNetworkWidget(
                          imageSrc: provider.movies[index].posterPath,
                          height: 200,
                          width: 120,
                          radius: 12,
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return MovieDetailPage(id: movie.id);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Center(child: Text('Not Found Now Playing Movies')),
            );
          },
        ),
      ),
    );
  }
}
