import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/app_constants.dart';
import 'package:tubes_movietrailer_app/main.dart';
import 'package:tubes_movietrailer_app/movie/components/movie_discover_components.dart';
import 'package:tubes_movietrailer_app/movie/components/movie_now_playing_component.dart';
import 'package:tubes_movietrailer_app/movie/components/movie_top_rated_component.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_pagination_page.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_search_page.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_discover_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_top_rated_provider.dart';
import 'package:tubes_movietrailer_app/widget/image_widget.dart';
import 'package:intl/intl.dart';
import 'package:tubes_movietrailer_app/widget/item_movie_widget.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          //bungkus menggunakan row untuk menampilkan logonya
          //bungkus juga dengan padding untuk mengatur ukuran logonya
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    'assets/images/logotrailerhub.png',
                  ),
                ),
              ),
              const Text(
                'Trailerhub',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => showSearch(
                context: context,
                delegate: MovieSearchPage(),
              ),
              icon: Icon(Icons.search),
            ),
          ],
          floating: true,
          snap: true,
          centerTitle: true,
          backgroundColor: Colors.white,
          //setting tulisan dan logo" nya
          foregroundColor: Colors.black,
        ),
        //buat satu widget lagi untuk menampilkan judul "Discover Movie"
        _WidgetTitle(
          title: 'Discover Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MoviePaginationPage(
                  type: TypeMovie.discover,
                ),
              ),
            );
          },
        ),
        const ComponentDiscoverMovie(),
        _WidgetTitle(
          title: 'Top Rated Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MoviePaginationPage(type: TypeMovie.topRated),
              ),
            );
          },
        ),
        //widgetnya kita panggil
        const MovieTopRatedComponent(),
        _WidgetTitle(
          title: 'Now Playing Movies',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MoviePaginationPage(type: TypeMovie.nowPlaying),
              ),
            );
          },
        ),
        const MovieNowPlayingComponent(),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 16,
          ),
        ),
      ],
    ));
  }
}

//buat widget private
//kenapa extends SliverToBoxAdapter karena membaca widget ini kedalam sliver ini dan
//widgetnya itu harus berbentu sliver
class _WidgetTitle extends SliverToBoxAdapter {
  final String title;
  final void Function() onPressed;

  const _WidgetTitle({required this.title, required this.onPressed});

  @override
  Widget? get child => Padding(
        padding: const EdgeInsets.all(16.0),
        //wrap with row untuk menambahkan satu tombol di samping titlenya
        child: Row(
          //atur agar jarak Discover Movie ke See All itu sama
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              //supaya titlenya bisa diubah ubah
              title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                shape: const StadiumBorder(), //supaya dia rounded
                side: const BorderSide(
                  color: Colors.black54,
                ),
              ),
              child: const Text('See All'),
            )
          ],
        ),
      );
}
