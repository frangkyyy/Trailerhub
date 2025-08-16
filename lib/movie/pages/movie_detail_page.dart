import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/injector.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_detail_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_videos_provider.dart';
import 'package:tubes_movietrailer_app/widget/image_widget.dart';
import 'package:tubes_movietrailer_app/widget/item_movie_widget.dart';
import 'package:tubes_movietrailer_app/widget/youtube_player_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key, required this.id}) : super(key: key);

  //nah ketika kita panggil MovieDetailPage ini, kita harus menyatakan id_movie nya melalui constructor
  final int id;

  @override
  Widget build(BuildContext context) {
    //ubah Container jadi ChangeNotifierProvider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //kita disini butuh _movieRepository sedangkan _movieRepository yang kita buat ada class main
          //yang ada di main.dart
          //jadi kita harus memasukan _movieRepository ke movie_detail_page
          //jadi kita pakai dependencies injection agar mempermudah memasukan repository ini kedalam
          //movie_detail_page.
          //get_it sebenarnya bukan dependencies injection tapi adalah service_locator.
          create: (_) =>
              sl<MovieGetDetailProvider>()..getDetail(context, id: id),
        ),
        ChangeNotifierProvider(
          //kita disini butuh _movieRepository sedangkan _movieRepository yang kita buat ada class main
          //yang ada di main.dart
          //jadi kita harus memasukan _movieRepository ke movie_detail_page
          //jadi kita pakai dependencies injection agar mempermudah memasukan repository ini kedalam
          //movie_detail_page.
          //get_it sebenarnya bukan dependencies injection tapi adalah service_locator.
          create: (_) =>
              sl<MovieGetVideosProvider>()..getVideos(context, id: id),
        ),
      ],
      builder: (_, __) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // Consumer<MovieGetDetailProvider>(
            //   builder: (_, provider, __) {
            //     if (provider.movie != null) {
            //       log(provider.movie.toString());
            //     }
            //     log(provider.movie.toString());
            //     return SliverAppBar(
            //       title:
            //           Text(provider.movie != null ? provider.movie!.title : ''),
            //     );
            //   },
            // )
            _WidgetAppBar(context),
            Consumer<MovieGetVideosProvider>(
              builder: (_, provider, __) {
                final videos = provider.videos;
                //cek kalo videos != null
                if (videos != null) {
                  return SliverToBoxAdapter(
                    child: _Content(
                      title: 'Trailer',
                      padding: 0,
                      body: SizedBox(
                        height: 160,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            //tampung dulu untuk videonya
                            final vidio = videos.results[index];
                            return Stack(
                              children: [
                                ImageNetworkWidget(
                                  radius: 12,
                                  type: TypeSrcImg.external,
                                  //imageSrc untuk mendapatkan thumbnail
                                  imageSrc: YoutubePlayer.getThumbnail(
                                    videoId: vidio.key,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32.0,
                                      ),
                                    ),
                                  ),
                                ),
                                //tambahkan fungsi onclick
                                Positioned.fill(
                                  child: Material(
                                    //pake ini supaya nanti keliatan waktu diklik
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        //panggil Navigator.push
                                        //youtubeKey ambil dari vidio.key
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => YoutubePlayerWidget(
                                              youtubeKey: vidio.key,
                                            ),
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
                            width: 8,
                          ),
                          itemCount: videos.results.length,
                        ),
                      ),
                    ),
                  );
                }
                //klo videos = null
                return const SliverToBoxAdapter();
              },
            ),
            //panggil _WidgetSummary()
            _WidgetSummary(),
          ],
        ),
      ),
    );
  }
}

class _WidgetAppBar extends SliverAppBar {
  //_ artinya private (hanya bisa diakses oleh class itu sendiri)
  //karena kita akan merender slivers nya, maka kita extend SliverAppBar

  //masukan Context
  //masukan melalui constructor
  final BuildContext context;

  const _WidgetAppBar(this.context);

  //atur background
  @override
  Color? get backgroundColor => Colors.white;

  //atur foregroundColor
  @override
  Color? get foregroundColor => Colors.black;

  //atur leading
  @override
  Widget? get leading => Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: IconButton(
            onPressed: () {
              //panggil Navigator.pop agar berfungsi tombolnya
              //karena butuh context, maka kita harus memasukan context ke dalam widget diatas
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      );

  // //tambahkan actions
  // @override
  // List<Widget>? get actions => [
  //       Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: CircleAvatar(
  //           backgroundColor: Colors.white,
  //           foregroundColor: Colors.black,
  //           child: IconButton(
  //             onPressed: () {},
  //             icon: const Icon(Icons.public),
  //           ),
  //         ),
  //       ),
  //     ];

  //gunakan expandedHeight
  @override
  double? get expandedHeight => 300;

  //tambahkan flexibleSpace = mengambil tinggi dari expandedHeight diatas
  @override
  Widget? get flexibleSpace => Consumer<MovieGetDetailProvider>(
        builder: (_, provider, __) {
          final movie = provider.movie;
          //cek jika movie nya != null
          if (movie != null) {
            //return ItemMovieWidget sama seperti widget discover movie
            return ItemMovieWidget(
              movieDetail: movie,
              //heightBackdrop setting infinity karena nanti terbatas oleh expandedHeight
              heightBackdrop: double.infinity,
              widthBackdrop: double.infinity,
              heightPoster: 160.0,
              widthPoster: 100.0,
              //atur radius=0 supaya radiunsya hilang
              radius: 0,
            );
          }

          //cek kalo dia null
          return Container(
            color: Colors.black12,
            height: double.infinity,
            width: double.infinity,
          );
        },
      );
}

//konten video trailer akan digunakan diluar class SliverToBoxAdapter dibawah
//maka kita buat class baru
class _Content extends StatelessWidget {
  const _Content(
      {Key? key, required this.title, required this.body, this.padding = 16.0})
      : super(key: key);

  final String title;
  final Widget body;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: body,
        ),
      ],
    );
  }
}

class _WidgetSummary extends SliverToBoxAdapter {
  TableRow _tableContent({required String title, required String content}) =>
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content),
        ),
      ]);

  @override
  Widget? get child => Consumer<MovieGetDetailProvider>(
        builder: (_, provider, __) {
          //bikin satu variabel movie
          final movie = provider.movie;
          //cek jika movienya null, return widget yang akan ditampilkan
          if (movie != null) {
            //pake Column karena nanti akan lebih dari satu baris
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //panggil widget _content
                _Content(
                  title: "Release Date",
                  body: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        size: 32.0,
                      ),
                      //kasih jarak
                      const SizedBox(
                        width: 6.0,
                      ),
                      Text(
                        movie.releaseDate.toString().split(' ').first,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                _Content(
                  title: 'Genres',
                  //wrap sejenis row tapi otomatis akan kebawah
                  body: Wrap(
                    spacing: 6,
                    children: movie.genres
                        .map((genre) => Chip(label: Text(genre.name)))
                        .toList(),
                  ),
                ),
                _Content(
                  title: 'Overview',
                  body: Text(movie.overview),
                ),
                _Content(
                  title: 'Summary',
                  //pake Table() karena akan banyak yang akan ditampilkan
                  body: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                    },
                    border: TableBorder.all(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    children: [
                      _tableContent(
                        title: "Adult",
                        content: movie.adult ? "Yes" : "No",
                      ),
                      _tableContent(
                        title: "Popularity",
                        content: '${movie.popularity}',
                      ),
                      _tableContent(
                        title: "Status",
                        content: movie.status,
                      ),
                      _tableContent(
                        title: "Budget",
                        content: '${movie.budget}',
                      ),
                      _tableContent(
                        title: "Revenue",
                        content: '${movie.revenue}',
                      ),
                      _tableContent(
                        title: "Tagline",
                        content: movie.tagline,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          //kalo dia null, return Container
          return Container();
        },
      );
}
