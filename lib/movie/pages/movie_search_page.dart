import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_search_provider.dart';
import 'package:tubes_movietrailer_app/widget/image_widget.dart';

import 'movie_detail_page.dart';

class MovieSearchPage extends SearchDelegate {
  @override
  String? get searchFieldLabel => "Search Movies";

  @override
  List<Widget>? buildActions(BuildContext context) {
    //buildActions itu jika di appbar itu ada Actions yang berada di sebelah kanan dan bisa ditambah tombol
    //buildActions itu nanti akan tampil di bagian kanan aplikasi kita
    //untuk Icon kita pake Icons.clear karena kalo kita menulis sesuatu di query nya itu,
    //querynya bisa kita hapus menggunakan function ini.
    return [
      IconButton(
        onPressed: () => query = "",
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  //menipiskan evelation pada appbar search movie
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      //ubah appBarTheme
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    //buildLeading itu ada di sebelah kiri aplikasi kita
    //untuk Icon nya menggunakan icon anak panah untuk kembali ke page sebelumnya
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
      color: Colors.black,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //panggil fungsi untuk mengambil data dari void search yang ada di file movie_search_provider.dart
    //supaya mendapatkan response dari server
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //function ini kita gunakan supaya kita menunggu fungsi Build ini selesai dilakukan
      //lalu memanggil function kita.
      //tapi sebelum memanggil functionnya, kita lihat di tmdb bahwa quernya itu minLength 1
      //jadi kita harus pastikan querynya tidak kosong
      if (query.isNotEmpty) {
        //panggil function kita
        context.read<MovieSearchProvider>().search(context, query: query);
      }
    });

    //buildResults itu ada di tengah aplikasi kita
    //untuk body nya, kita return Consumer
    return Consumer<MovieSearchProvider>(
      builder: (_, provider, __) {
        //cek jika kondisinya query nya kosong
        if (query.isEmpty) {
          return const Center(
            child: Text("Search Movies"),
          );
        }

        //cek dlu untuk providernya apakah dia isLoading
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        //cek jika kosong
        if (provider.movies.isEmpty) {
          return const Center(
            child: Text("Movies Not Found"),
          );
        }

        ///cek jika isNotEmpty
        if (provider.movies.isNotEmpty) {
          return ListView.separated(
            //padding untuk jarak gambar dengan appbar
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              //buat satu variabel namanya movie
              final movie = provider.movies[index];
              //widgetnya menggunakan row karena ingin ada foto dan judulnya
              return Stack(
                children: [
                  Row(
                    children: [
                      ImageNetworkWidget(
                        imageSrc: movie.posterPath,
                        height: 120,
                        width: 80,
                        //berikan radius di gambarnya
                        radius: 10,
                      ),
                      //berikan jarak
                      const SizedBox(
                        width: 10,
                      ),
                      //tambahkan teks untuk titlenya
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //ingin agar dibawahnya ada overview
                            Text(
                              movie.overview,
                              maxLines: 3,
                              overflow: TextOverflow
                                  .ellipsis, //ellipsis itu titik titik
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            //jarak diantara tulisan overview
                            const SizedBox(
                              height: 8,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) {
                              return MovieDetailPage(id: movie.id);
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              //jarak antar gambar movie nya
              height: 10,
            ),
            itemCount: provider.movies.length,
          );
        }

        //klo gk ada dari kondisi kita
        return const Center(child: Text("Another Error on search movies"));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //buildSuggestions belum gunakan dulu
    return const SizedBox();
  }
}
