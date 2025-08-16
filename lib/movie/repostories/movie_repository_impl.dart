//file ini akan mengimplement fungsi" class abstract
//yang ada di movie_repository.dart tadi.
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_detail_model.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_model.dart';
import 'package:tubes_movietrailer_app/movie/models/movie_video_model.dart';
import 'package:tubes_movietrailer_app/movie/repostories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  //untuk menghubungkan flutter ke rest API/server, kita memerlukan http client
  //dengan menambahkan dio.
  //bikin objek Dio dan beri nama _dio
  final Dio _dio; //objek _dio ini akan kita inject dari luar

  //kita masukan object Dio _dio dari constructor
  MovieRepositoryImpl(this._dio);

  //jadi setiap kita buat objek ini, maka secara required, kita harus mengisi
  //objek ini(Dio) dan objeknya di inject dari luar

  //turunan dari movie_repository.dart
  @override
  //kalo fungsinya Future, tambahkan async
  Future<Either<String, MovieResponseModel>> getDiscover({int page = 1}) async {
    //buat requestnya dan simpan di variabel result
    //panggil objek Dio tadi
    //pathnya kita pakai /discover/movie
    //page nya simpan di query parameter sesuai dokumentasi get tmdbnya
    //pake await untuk menghilangkan kembalian berupa Future dalam variabel result.
    //buat try catch untuk menangkap errornya
    try {
      final result = await _dio.get(
        '/discover/movie',
        queryParameters: {'page': page},
      );
      //untuk api_key tidak dimasukan ke dalam queryParameters diatas.
      //di objek Dio ada options yang dimana bisa mengatur baseUrl dan queryParameters globalnya.

      //cek status code == 200?
      //jika kondisi terpenuhi, maka otomatis result.datanya itu ada
      //maka data yang tadinya tipenya dynamic/raw json menjadi MovieResponseModel kita.
      if (result.statusCode == 200 && result.data != null) {
        //fromMap untuk mengambil raw json yang kita dapatkan dari final result.
        final model = MovieResponseModel.fromMap(result
            .data); //result.data= raw json yang telah kita dapatkan dari result diatas
        return Right(
            model); //Right akan mengambil modelnya (MovieResponseModel)
      }

      //kalo data tidak berhasil diambil, kita throw errornya.
      //Left akan mengambil pesan error dalam bentuk String
      return const Left('Error get discover movies');

      //kita pake objek Dio jadi yang ditangkap adalah error Dio nya
      //error jika statusCode itu 401/404
    } on DioError catch (e) {
      if (e.response != null) {
        return Left(e.response.toString());
      }

      return const Left('Another error on get discover movies');
    }
  }

  //class buat Popular Movies
  @override
  Future<Either<String, MovieResponseModel>> getTopRated({int page = 1}) async {
    try {
      //panggil fungsi await dari class http client nya(_dio).
      //tampung ke dalam variabel final result
      final result = await _dio.get(
        '/movie/top_rated',
        queryParameters: {'page': page},
      );

      //cek
      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromMap(result.data);
        return Right(model);
      }

      return const Left('Error get top rated movies');
    } on DioError catch (e) {
      //cek
      if (e.response != null) {
        return Left(e.response.toString());
      }
      //klo kondisinya tidak terpenuhi
      return const Left('Another error on get top rated movies');
    }
  }

  @override
  Future<Either<String, MovieResponseModel>> getNowPlaying(
      {int page = 1}) async {
    try {
      final result = await _dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );
      //kondisinya
      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromMap(result.data);
        return Right(model);
      }

      return const Left('Error get now playing movies');
    } on DioError catch (e) {
      //cek
      if (e.response != null) {
        return Left(e.response.toString());
      }
      //klo kondisinya tidak terpenuhi
      return const Left('Another error on get now playing movies');
    }
  }

  @override
  Future<Either<String, MovieDetailModel>> getDetail({required int id}) async {
    try {
      final result = await _dio.get(
        '/movie/$id', //tidak butuh query parameter karena bersifat path
        // queryParameters: {'page': page},
      );
      //kondisinya
      if (result.statusCode == 200 && result.data != null) {
        final model = MovieDetailModel.fromMap(result.data);
        return Right(model);
      }

      return const Left('Error get movie detail');
    } on DioError catch (e) {
      //cek
      if (e.response != null) {
        return Left(e.response.toString());
      }
      //klo kondisinya tidak terpenuhi
      return const Left('Another error on get now movie detail');
    }
  }

  @override
  Future<Either<String, MovieVideosModel>> getVideos({required int id}) async {
    try {
      final result = await _dio.get(
        '/movie/$id/videos', //tidak butuh query parameter karena bersifat path
        // queryParameters: {'page': page},
      );
      //kondisinya
      if (result.statusCode == 200 && result.data != null) {
        final model = MovieVideosModel.fromMap(result.data);
        return Right(model);
      }

      return const Left('Error get movie videos');
    } on DioError catch (e) {
      //cek
      if (e.response != null) {
        return Left(e.response.toString());
      }
      //klo kondisinya tidak terpenuhi
      return const Left('Another error on get movie videos');
    }
  }

  @override
  Future<Either<String, MovieResponseModel>> search({
    required String query,
  }) async {
    try {
      final result = await _dio.get(
        '/search/movie', //tidak butuh query parameter karena bersifat path
        queryParameters: {'query': query},
      );
      //kondisinya
      if (result.statusCode == 200 && result.data != null) {
        final model = MovieResponseModel.fromMap(result.data);
        return Right(model);
      }

      return const Left('Error search movie');
    } on DioError catch (e) {
      //cek
      if (e.response != null) {
        return Left(e.response.toString());
      }
      //klo kondisinya tidak terpenuhi
      return const Left('Another error on search movie');
    }
  }
}
