//dibuat abstract class agar nantinya class ini digunakan sebagai kontrak untuk
//fungsi" apa saja yang akan digunakan nanti
//fungsi fungsinya otomatis diturunkan ke implementasinya.
import 'package:dartz/dartz.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_detail_model.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_video_model.dart';

abstract class MovieRepository {
  //fungsi pertama adalah mengambil discover movie nya.
  //kita memerlukan parameter page untuk mengambil page selanjutnya.
  //buat default value = 1 agar nanti di provider kita ketika kita ambil fungsi
  //getDiscover lalu kita tidak isi parameternya, maka otomatis page yang diambil
  //adalah page 1

  //Either:class yang ada di dartz dan harus kita isi dua buah kembalian
  //(L dan R)
  //L (Left) = data yang error
  //R (Right) = data yang benar
  //String karena ketika error, kita hanya menampilkan pesan error dalam bentuk String
  //sesuai yang ada pada throw di file movie_repository_impl.
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1});
  Future<Either<String, MovieResponseModel>> getTopRated({int page = 1});
  Future<Either<String, MovieResponseModel>> getNowPlaying({int page = 1});
  Future<Either<String, MovieResponseModel>> search({required String query});
  Future<Either<String, MovieDetailModel>> getDetail({required int id});
  Future<Either<String, MovieVideosModel>> getVideos({required int id});
}
