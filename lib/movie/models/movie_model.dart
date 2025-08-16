// import 'dart:convert';

class MovieResponseModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  MovieResponseModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  //kode dibawah ini belum digunakan, jadi command dahulu
  // factory MovieResponseModel.fromJson(String str) =>
  //     MovieResponseModel.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  //kode dibawah nanti akan diambil dan dikonversi ke dalam model kita (MovieResponseModel)
  factory MovieResponseModel.fromMap(Map<String, dynamic> json) =>
      MovieResponseModel(
        page: json["page"],
        results: List<MovieModel>.from(
            json["results"].map((x) => MovieModel.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  // Map<String, dynamic> toMap() => {
  //       "page": page,
  //       "results": List<dynamic>.from(results.map((x) => x.toMap())),
  //       "total_pages": totalPages,
  //       "total_results": totalResults,
  //     };
}

class MovieModel {
  final String? backdropPath;
  final int id;
  final String overview;
  final String? posterPath;
  final String title;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    //hapus required backdropPath dan posterPath karena bisa null
    //di response jsonnya
    this.backdropPath,
    required this.id,
    required this.overview,
    this.posterPath,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  // kode ini juga belum digunakan, jadi dicommand dulu
  // factory MovieModel.fromJson(String str) =>
  //     MovieModel.fromMap(json.decode(str));

  // String toJson() => json.encode(toMap());

  // kode ini yang kita gunakan untuk merubah json menjadi class model kita
  factory MovieModel.fromMap(Map<String, dynamic> json) => MovieModel(
        // dibandingkan nilai null, lebih baik mengembalikan string kosong saja
        //dicek apabila backdropnya null, kita kembalikan string kosong
        //begitu juga untuk posterpath
        backdropPath: json["backdrop_path"] ?? '',
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? '',
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  // Map<String, dynamic> toMap() => {
  //       "adult": adult,
  //       "backdrop_path": backdropPath,
  //       "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
  //       "id": id,
  //       "original_language": originalLanguage,
  //       "original_title": originalTitle,
  //       "overview": overview,
  //       "popularity": popularity,
  //       "poster_path": posterPath,
  //       "release_date":
  //           "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
  //       "title": title,
  //       "video": video,
  //       "vote_average": voteAverage,
  //       "vote_count": voteCount,
  //     };
}
