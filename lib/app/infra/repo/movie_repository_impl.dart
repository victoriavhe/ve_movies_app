
import 'package:either_dart/either.dart';
import 'package:ve_movies_app/app/domain/repository/movie_repository.dart';
import 'package:ve_movies_app/app/helper/error/failure.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApi movieApi;

  MovieRepositoryImpl({required this.movieApi});

  @override
  Future<Either<Failure, MovieResponseDto>> getPopularMovies({int page = 1}) {
    return movieApi.getPopularMovies(page: page);
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getTopRatedMovies({int page = 1}) {
    return movieApi.getTopRatedMovies(page: page);
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getNowPlayingMovies({int page = 1}) {
    return movieApi.getNowPlayingMovies(page: page);
  }

  @override
  Future<Either<Failure, MovieResponseDto>> getUpcomingMovies({int page = 1}) {
    return movieApi.getUpcomingMovies(page: page);
  }

  @override
  Future<Either<Failure, MovieResponseDto>> searchMovies({
    required String query,
    int page = 1,
  }) {
    return movieApi.searchMovies(query: query, page: page);
  }
}