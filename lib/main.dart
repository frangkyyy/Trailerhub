// main.dart:

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:tubes_movietrailer_app/app_constants.dart';
import 'package:tubes_movietrailer_app/injector.dart';
import 'package:tubes_movietrailer_app/movie/pages/movie_page.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_discover_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_now_playing_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_top_rated_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_search_provider.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository_impl.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(App());
  FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //MultiProvider karena nanti akan lebih dari 1 provider
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            //panggil class MovieGetDiscoverProvider
            //pada saat membuat provider kita, MovieGetDiscoverProvider memerlukan
            //MovieRepository, kita buat dlu MovieRepository di void main() diatas.
            create: (context) => sl<MovieGetDiscoverProvider>(),
          ),
          ChangeNotifierProvider(
            //panggil class MovieGetDiscoverProvider
            //pada saat membuat provider kita, MovieGetDiscoverProvider memerlukan
            //MovieRepository, kita buat dlu MovieRepository di void main() diatas.
            create: (context) => sl<MovieGetTopRatedProvider>(),
          ),
          ChangeNotifierProvider(
            //panggil class MovieGetNowPlayingProvider
            //pada saat membuat provider kita, MovieGetNowPlayingProvider memerlukan
            //MovieRepository, kita buat dlu MovieRepository di void main() diatas.
            create: (context) => sl<MovieGetNowPlayingProvider>(),
          ),
          ChangeNotifierProvider(
            //panggil class MovieSearchProvider
            //pada saat membuat provider kita, MovieSearchProvider memerlukan
            //MovieRepository, kita buat dlu MovieRepository di void main() diatas.
            create: (context) => sl<MovieSearchProvider>(),
          ),
        ],
        child: MaterialApp(
            title: 'Trailerhub',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              primaryColor: Colors.blue,
              useMaterial3: true,
            ),
            home: const MoviePage()));
  }
}


//jadi MovieGetDiscoverProvider ini dapat kita gunakan di seluruh page aplikasi
//kita karena kita meregistrasi provider ini diatas class MaterialApp().