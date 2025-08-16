import 'package:flutter/material.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieSearchProvider with ChangeNotifier {
  //butuh MovieRepository
  final MovieRepository _movieRepository;

  MovieSearchProvider(this._movieRepository);

  //buat satu variabel _isLoading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //buat lagi final List
  //karena dia mengembalikan MovieModel, kita tampung MovieModel di variabel _movies
  final List<MovieModel> _movies = [];
  List<MovieModel> get movies => _movies;

  //bikin function void search
  void search(BuildContext context, {required String query}) async {
    //logikanya itu sama seperti void getDiscover yang ada di file movie_get_discover_provider.dart
    _isLoading = true;
    //memberitahu provider bahwa _isLoading ini true dengan memanggil notifyListeners();
    notifyListeners();
    //panggil fungsi getDiscover yang ada di class movie_repository.dart
    //untuk getDiscover ini kita hanya memerlukan page pertama.
    //getDiscover berbentuk Future, jadi tambahkan async di voidnya dan await
    final result = await _movieRepository.search(query: query);
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
        return;
      },
    );
  }
}
