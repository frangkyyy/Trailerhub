import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_detail_page.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_discover_provider.dart';
import 'package:tubes_movietrailer_app/widget/item_movie_widget.dart';

class ComponentDiscoverMovie extends StatefulWidget {
  const ComponentDiscoverMovie({Key? key}) : super(key: key);

  @override
  _ComponentDiscoverMovieState createState() => _ComponentDiscoverMovieState();
}

class _ComponentDiscoverMovieState extends State<ComponentDiscoverMovie> {
  @override
  //di initState kita panggil fungsi:
  //WidgetsBinding.instance.addPostFrameCallback((_) {
  //context.read<MovieGetDiscoverProvider>().getDiscover(context);
  //});
  //fungsi initState ini hanya dipanggil saat stateful diatas dibuat
  void initState() {
    //bungkus fungsi ini dengan WidgetBinding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //panggil fungsi void getDiscover() yang ada di
      //movie_get_discover_provider.dart untuk mengambil datanya
      context.read<MovieGetDiscoverProvider>().getDiscover(context);
      //setelah ambil datanya, datanya kita dengarkan di Consumer() -> widget dari providernya.
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<MovieGetDiscoverProvider>(
        builder: (_, provider, __) {
          //context, provider, child
          //cek:
          //apabila providernya isLoading, maka akan menampilkan widget Center child: CircularProgressIndicator
          if (provider.isLoading) {
            return Container(
              //margin agar loadingnya sesuai dengan gambarnya
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              //buat agar loadingnya mengikut gambarnya
              height: 300.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }
          //cek apabila data list movies nya tidak kosong, return
          if (provider.movies.isNotEmpty) {
            return CarouselSlider.builder(
              itemCount: provider.movies.length,
              itemBuilder: (_, index, __) {
                final movie = provider.movies[index];
                //untuk gambar tidak hanya di tempat ini saja kita pake,
                //tapi dipake di beberapa tempat, jadinya widget dibawah akan
                //dibuat widget global untuk mengambil gambar gambar yang
                //dirender di aplikasi kita
                //widget dibawah akan dijadikan sebuah widget karena nanti widget ini
                //digunakan untuk paginationnya nanti
                //return IteMovie
                return ItemMovieWidget(
                  movie: movie,
                  heightBackdrop: 300,
                  widthBackdrop: double.infinity,
                  heightPoster: 160,
                  widthPoster: 100,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) {
                        return MovieDetailPage(id: movie.id);
                      },
                    ));
                  },
                );
              },
              options: CarouselOptions(
                height: 300.0,
                viewportFraction: 0.8,
                reverse: false,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            );
          }

          //kondisi apabila datanya kosong/error
          return Container(
            //margin agar loadingnya sesuai dengan gambarnya
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            //buat agar loadingnya mengikut gambarnya
            height: 300.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              //kalo gambar tidak ada, muncul Discover Movie Not Found
              child: Text(
                'Discover Movie Not Found',
                style: TextStyle(color: Colors.black45),
              ),
            ),
          );
        },
      ),
    );
  }
}
