import 'package:either_dart/either.dart';
import 'package:ve_movies_app/app/helper/error/failure.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';

abstract class MovieApi {
  Future<Either<Failure, MovieResponseDto>> getPopularMovies({int page = 1});
  Future<Either<Failure, MovieResponseDto>> getTopRatedMovies({int page = 1});
  Future<Either<Failure, MovieResponseDto>> getNowPlayingMovies({int page = 1});
  Future<Either<Failure, MovieResponseDto>> getUpcomingMovies({int page = 1});
  Future<Either<Failure, MovieResponseDto>> searchMovies({
    required String query,
    int page = 1,
  });
}