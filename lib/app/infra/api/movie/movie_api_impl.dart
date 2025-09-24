import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:ve_movies_app/app/core/network/config/api_config.dart';
import 'package:ve_movies_app/app/helper/error/failure.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';

class MovieApiImpl extends MovieApi {
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${ApiConfig.bearerToken}',
    'Content-Type': 'application/json',
  };

  @override
  Future<Either<Failure, MovieResponseDto>> getTopRatedMovies({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?page=$page'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Right(movieResponseDtoFromJson(response.body));
      } else {
        return Left(
          ServerFailure(
            message: 'Failed to load top rated movies: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getNowPlayingMovies({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/now_playing?page=$page'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Right(movieResponseDtoFromJson(response.body));
      } else {
        return Left(
          ServerFailure(
            message:
                'Failed to load now playing movies: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getUpcomingMovies({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/upcoming?page=$page'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Right(movieResponseDtoFromJson(response.body));
      } else {
        return Left(
          ServerFailure(
            message: 'Failed to load upcoming movies: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, MovieResponseDto>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/search/movie?query=${Uri.encodeComponent(query)}&page=$page',
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Right(movieResponseDtoFromJson(response.body));
      } else {
        return Left(
          ServerFailure(
            message: 'Failed to search movies: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error: ${e.toString()}'));
    }
  }

  // Helper method to get full poster URL
  static String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) return '';
    return '$_imageBaseUrl$posterPath';
  }

  // Helper method to get backdrop URL
  static String getBackdropUrl(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w780$backdropPath';
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getPopularMovies({
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?page=$page'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Right(movieResponseDtoFromJson(response.body));
      } else {
        return Left(
          ServerFailure(
            message: 'Failed to load popular movies: ${response.statusCode}',
            statusCode: response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(message: 'Network error: ${e.toString()}'));
    }
  }
}
