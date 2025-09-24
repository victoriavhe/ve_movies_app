// To parse this JSON data, do
//
//     final movieResponseDto = movieResponseDtoFromJson(jsonString);

import 'dart:convert';

MovieResponseDto movieResponseDtoFromJson(String str) => MovieResponseDto.fromJson(json.decode(str));

String movieResponseDtoToJson(MovieResponseDto data) => json.encode(data.toJson());

class MovieResponseDto {
  final int? page;
  final List<MovieDto>? results;
  final int? totalPages;
  final int? totalResults;

  MovieResponseDto({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  MovieResponseDto copyWith({
    int? page,
    List<MovieDto>? results,
    int? totalPages,
    int? totalResults,
  }) =>
      MovieResponseDto(
        page: page ?? this.page,
        results: results ?? this.results,
        totalPages: totalPages ?? this.totalPages,
        totalResults: totalResults ?? this.totalResults,
      );

  factory MovieResponseDto.fromJson(Map<String, dynamic> json) => MovieResponseDto(
    page: json["page"],
    results: json["results"] == null ? [] : List<MovieDto>.from(json["results"]!.map((x) => MovieDto.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}

class MovieDto {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int? id;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  MovieDto({
    this.adult,
    this.backdropPath,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  MovieDto copyWith({
    bool? adult,
    String? backdropPath,
    List<int>? genreIds,
    int? id,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    String? releaseDate,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
  }) =>
      MovieDto(
        adult: adult ?? this.adult,
        backdropPath: backdropPath ?? this.backdropPath,
        genreIds: genreIds ?? this.genreIds,
        id: id ?? this.id,
        originalLanguage: originalLanguage ?? this.originalLanguage,
        originalTitle: originalTitle ?? this.originalTitle,
        overview: overview ?? this.overview,
        popularity: popularity ?? this.popularity,
        posterPath: posterPath ?? this.posterPath,
        releaseDate: releaseDate ?? this.releaseDate,
        title: title ?? this.title,
        video: video ?? this.video,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  factory MovieDto.fromJson(Map<String, dynamic> json) => MovieDto(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
    id: json["id"],
    originalLanguage: json["original_language"],
    originalTitle: json["original_title"],
    overview: json["overview"],
    popularity: json["popularity"]?.toDouble(),
    posterPath: json["poster_path"],
    releaseDate: json["release_date"],
    title: json["title"],
    video: json["video"],
    voteAverage: json["vote_average"]?.toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "genre_ids": genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
    "id": id,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "release_date": releaseDate,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };
}
