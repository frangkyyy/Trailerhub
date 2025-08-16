import 'package:flutter/material.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_video_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieGetVideosProvider with ChangeNotifier {
  final MovieRepository _movieRepository;

  //inject ke dalam constructor
  MovieGetVideosProvider(this._movieRepository);

  //buat satu variabel dengan nama MovieDetailModel
  MovieVideosModel? _videos;
  //buat getter nya
  MovieVideosModel? get videos => _videos;

  //buat fungsi untuk mengambil detail
  //butuh BuildContext untuk menampilkan snackbar
  void getVideos(BuildContext context, {required int id}) async {
    //pada saat kita memanggil fungsi detail, kita pastikan movienya itu null
    _videos = null;
    //kita beritahu providernya jika movienya null
    notifyListeners();
    //panggil repository dan tampung di variabel result
    final result = await _movieRepository.getVideos(id: id);
    //result nya kita fold
    result.fold(
      (messageError) {
        //tampilkan ScaffoldMessenger
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(messageError)),
        );
        //klo error, movienya null
        _videos = null;
        //beritahu providernya
        notifyListeners();
        return;
      },
      (response) {
        //langsung saja set movie nya = response karena response ini tipenya MovieDetailModel
        _videos = response;
        notifyListeners();
        return;
      },
    );
  }
}
