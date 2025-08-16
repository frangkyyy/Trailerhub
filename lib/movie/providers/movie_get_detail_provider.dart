import 'package:flutter/material.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_detail_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieGetDetailProvider with ChangeNotifier {
  //butuh repository
  final MovieRepository
      _movieRepository; //buat private karena nanti diinject dari constructor

  MovieGetDetailProvider(this._movieRepository);

  //buat satu variabel dengan nama MovieDetailModel
  MovieDetailModel? _movie;
  //buat getter nya
  MovieDetailModel? get movie => _movie;

  //buat fungsi untuk mengambil detail
  //butuh BuildContext untuk menampilkan snackbar
  void getDetail(BuildContext context, {required int id}) async {
    //pada saat kita memanggil fungsi detail, kita pastikan movienya itu null
    _movie = null;
    //kita beritahu providernya jika movienya null
    notifyListeners();
    //panggil repository dan tampung di variabel result
    final result = await _movieRepository.getDetail(id: id);
    //result nya kita fold
    result.fold(
      (messageError) {
        //tampilkan ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );
        //klo error, movienya null
        _movie = null;
        //beritahu providernya
        notifyListeners();
        return;
      },
      (response) {
        //langsung saja set movie nya = response karena response ini tipenya MovieDetailModel
        _movie = response;
        notifyListeners();
        return;
      },
    );
  }
}
