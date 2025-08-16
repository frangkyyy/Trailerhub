import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieGetNowPlayingProvider with ChangeNotifier {
  //butuh movie repository kelas abstrak dengan nama _movieRepository
  //masukan objeknya melalui constructor.
  final MovieRepository _movieRepository;

  MovieGetNowPlayingProvider(this._movieRepository);

  //buat variabel _isLoading
  bool _isLoading = false;
  //bikin fungsi getter
  bool get isLoading => _isLoading;
  //bikin final List
  //buat variabel _movies yang akan menampung response yang kita dapatkan nanti
  //kasih default value list kosong
  final List<MovieModel> _movies = [];
  //bikin getter nya
  List<MovieModel> get movies => _movies;

  //bikin function
  void getNowPlaying(BuildContext context) async {
    //set jadi true ketika sedang mengambil data
    _isLoading = true;
    notifyListeners();

    final result = await _movieRepository.getNowPlaying();
    result.fold(
      (messageError) {
        //tampilkan message dengan ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );
        //beritahu ke consumer klo datanya itu gagal diambil
        _isLoading = false;
        notifyListeners();
        return;
      },
      (response) {
        //clear dulu movienya
        _movies.clear();
        //set dari response result
        _movies.addAll(response.results);
        //set loadingnya = false
        _isLoading = false;
        //update ui nya menggunakan notifyListeners
        notifyListeners();
        return;
      },
    );
  }

  void getNowPlayingWithPaging(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    final result = await _movieRepository.getNowPlaying(page: page);
    result.fold(
      (messageError) {
        //tampilkan message dengan ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );
        //klo error kita beritahu messageError.
        pagingController.error = messageError;
        return;
      },
      (response) {
        if (response.results.length < 20) {
          //jika panjangnya < 20, kita anggap ini page terakhir.
          //atur pagingController
          pagingController.appendLastPage(response.results);
        } else {
          //apabila bukan lastPage
          //atur appendPage
          pagingController.appendPage(response.results, page + 1);
        }
        return;
      },
    );
  }
}
