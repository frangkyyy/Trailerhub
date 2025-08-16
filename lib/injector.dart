//siapkan injectornya
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_detail_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_discover_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_now_playing_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_top_rated_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_get_videos_provider.dart';
import 'package:tubes_movietrailer_app/movie/providers/movie_search_provider.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository_impl.dart';

import 'app_constants.dart';

//sl = singkatan service locator
final sl = GetIt.instance;

//buat satu fungsi
void setup() {
  //REGISTER KEEMPAT PROVIDER
  sl.registerFactory<MovieGetDiscoverProvider>(() => MovieGetDiscoverProvider(
      sl())); //nanti dia mencari movierepository dalam object sl ini
  sl.registerFactory<MovieGetTopRatedProvider>(
      () => MovieGetTopRatedProvider(sl()));
  sl.registerFactory<MovieGetNowPlayingProvider>(
      () => MovieGetNowPlayingProvider(sl()));
  sl.registerFactory<MovieGetDetailProvider>(
      () => MovieGetDetailProvider(sl()));
  sl.registerFactory<MovieGetVideosProvider>(
      () => MovieGetVideosProvider(sl()));
  sl.registerFactory<MovieSearchProvider>(() => MovieSearchProvider(sl()));

  // REGISTRASI REPOSITORY
  //lazy ini dipanggil dulu baru dibuild.
  //hapus MovieRepository yang ada di main.dart dan kita panggil MovieRepository yang ada di
  //main.dart yang tipenya abstrak dan mengembalikan MovieRepositoryImpl
  //nah untuk _dio nya, kalo sebelumnya itu dio nya itu dimasukan secara manual, kita tinggal panggil sl.
  //nanti secara pintar, class ini membutuhkan apa dan mencari di dalam class setup ini yang sudah diregistrasi.
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));

  // REGISTER HTTP CLIENT (DIO) menggunakan registerLazySingleton
  //dalam main.dart, dio nya kita buat secara manual jadi otomatis semua repository yang membutuhkan
  //dio ini akan kita inject ke classnya masing" secara manual, nanti si injector ini secara pintar
  //akan mengetahui repository/class" apa saja yang membutuhkan dio ini, dia nanti yang akan meneruskan
  //class dio ini kedalam constructor class" yang membutuhkan
  sl.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          //atur juga parameter untuk menambahkan apiKey
          queryParameters: {'api_key': AppConstants.apiKey},
        ),
      ));
}


//- setiap provider itu membutuhkan repository, repositorynya itu kita register di kode
// sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
// - setiap repository nya itu Membutuhkan Dio, dio nya itu kita register di kode
// sl.registerLazySingleton<Dio>(() => Dio(
//         BaseOptions(
//           baseUrl: AppConstants.baseUrl,
//           //atur juga parameter untuk menambahkan apiKey
//           queryParameters: {'api_key': AppConstants.apiKey},
//         ),
//       ));
// - Dio ini Membutuhkan options yang dimana options nya itu sudah langsung diberikan disitunya.
