import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:ve_movies_app/app/domain/repository/movie_repository.dart';
import 'package:ve_movies_app/app/helper/error/failure.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';

class GetMoviesParams extends Equatable {
  final MovieCategory? category;
  final String? query;
  final int page;

  const GetMoviesParams({
    this.category,
    this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [category, query, page];
}

class GetMoviesUsecase {
  final MovieRepository repository;

  GetMoviesUsecase({required this.repository});

  Future<Either<Failure, MovieResponseDto>> call(GetMoviesParams params) async {
    if (params.query != null && params.query!.isNotEmpty) {
      return await repository.searchMovies(
        query: params.query!,
        page: params.page,
      );
    }

    switch (params.category) {
      case MovieCategory.popular:
        return await repository.getPopularMovies(page: params.page);
      case MovieCategory.topRated:
        return await repository.getTopRatedMovies(page: params.page);
      case MovieCategory.nowPlaying:
        return await repository.getNowPlayingMovies(page: params.page);
      case MovieCategory.upcoming:
        return await repository.getUpcomingMovies(page: params.page);
      default:
        return await repository.getPopularMovies(page: params.page);
    }
  }
}