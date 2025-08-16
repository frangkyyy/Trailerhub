import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

//ChangeNotifier yang akan memberitahu providernya jika ada perubahan state di
//dalam providernya.
class MovieGetDiscoverProvider with ChangeNotifier {
  //hubungkan provider ke movie_repository
  final MovieRepository _movieRepository; //private

  //jadi class ini membutuhkan MovieRepository dan MovieRepository ini akan
  //kita masukan melalui constructor dibawah
  MovieGetDiscoverProvider(this._movieRepository);

  //memberitahu tampilan kita kalo sedang mengambil data
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MovieModel> _movies = [];
  //file getternya
  List<MovieModel> get movies => _movies;

  void getDiscover(BuildContext context) async {
    _isLoading = true;
    //memberitahu provider bahwa _isLoading ini true dengan memanggil notifyListeners();
    notifyListeners();
    //panggil fungsi getDiscover yang ada di class movie_repository.dart
    //untuk getDiscover ini kita hanya memerlukan page pertama.
    //getDiscover berbentuk Future, jadi tambahkan async di voidnya dan await
    final result = await _movieRepository.getDiscover();
    //result diatas kembaliannya adalah Either, tambahkan properti fold
    //fold: memisahkan error(String) dan berhasil(MovieResponseModel)
    result.fold(
      (errorMessage) {
        //tampilkan snackbar jika gagal
        //context kita ambil pada saat kita memanggil fungsi getDiscover
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              errorMessage), //errorMessage yang ada di movie_repository_impl apabila gagal.
        ));
        //beritahu tampilan kita jika errornya datanya tidak loading lagi dan datanya gagal diambil
        _isLoading = false;
        notifyListeners();
        return;
      },
      (response) {
        //sebelum menambahkan list movie ke list, harus mengclear lisnya terlebih dahulu
        _movies.clear();
        //results isinya List<MovieModel> maka kita bikin satu variabel di dalam
        //provider kita.
        _movies.addAll(response.results);
        _isLoading = false;
        notifyListeners();
        return null;
      },
    );
  }

  void getDiscoverWithPaging(BuildContext context,
      {required PagingController pagingController, required int page}) async {
    final result = await _movieRepository.getDiscover(page: page);
    //result diatas kembaliannya adalah Either, tambahkan properti fold
    //fold: memisahkan error(String) dan berhasil(MovieResponseModel)
    result.fold(
      (errorMessage) {
        //tampilkan snackbar jika gagal
        //context kita ambil pada saat kita memanggil fungsi getDiscover
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              errorMessage), //errorMessage yang ada di movie_repository_impl apabila gagal.
        ));

        //beritahu controllernya jika datanya itu error
        pagingController.error = errorMessage;

        //beritahu tampilan kita jika errornya datanya tidak loading lagi dan datanya gagal diambil.
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
