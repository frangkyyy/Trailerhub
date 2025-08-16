import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieGetTopRatedProvider with ChangeNotifier {
  //butuh repository
  //kita panggil class abstraknya
  final MovieRepository _movieRepository;

  //inject class implementasinya itu kedalam constructor
  MovieGetTopRatedProvider(this._movieRepository);

  //buat satu variabel private
  bool _isLoading = false;
  //buat fungsi getter untuk mengambil variabel _isLoading
  bool get isLoading => _isLoading;

  //buat variabel movies untuk menampung movie response yang kita dapatkan dari postman
  //buat dalam bentuk list
  final List<MovieModel> _movies = [];
  //buat variabel getternya
  List<MovieModel> get movies => _movies;

  //buat dua buah function
  //function pertama: untuk mengambil halaman pertama popular movies nya.
  //butuh BuildContext untuk menampilkan snackbar
  void getTopRated(BuildContext context) async {
    //sebelum mengambil movienya, setting _isLoadingnya jadi true dulu.
    _isLoading = true;
    //untuk memberitahun bahwa tampilannya true, kita panggil notifyListeners()
    notifyListeners();

    //panggil _movieRepository
    final result = await _movieRepository.getTopRated();

    //buat dalam block body
    result.fold(
      (messageError) {
        //kalo error, tampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );

        //klo error, ubah _isLoading jadi false
        _isLoading = false;
        notifyListeners();

        return;
      },
      (response) {
        //sebelum set movienya, clear dlu
        //takutnya ketika kita ambil datanya lagi, _movies ini masih ada isinya.
        _movies.clear();
        _movies.addAll(response.results);

        //beritahu tampilan kita kalo datanya sudah tidak loading
        _isLoading = false;
        notifyListeners();

        return;
      },
    );
  }

  //function kedua: untuk mengambil datanya page per page.
  //untuk pagination nya, butuh required int page.
  //klo kita liat di movie_pagination_page.dart itu ada _pagingController,
  //_pagingController itu akan dimasukan ke dalam providernya
  void getTopRatedWithPaging(
    BuildContext context, {
    required PagingController pagingController,
    required int page,
  }) async {
    //eksekusi
    final result = await _movieRepository.getTopRated(page: page);

    //buat dalam block body
    result.fold(
      (messageError) {
        //kalo error, tampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );

        pagingController.error = messageError;

        return;
      },
      (response) {
        //isinya sama seperti movie_get_discover_provider.dart
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
