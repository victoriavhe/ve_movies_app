part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieRefreshing extends MovieState {
  final List<MovieDto> movies;
  MovieRefreshing({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class MovieLoadingMore extends MovieState {
  final List<MovieDto> movies;
  final int currentPage;

  MovieLoadingMore({required this.movies, required this.currentPage});

  @override
  List<Object?> get props => [movies, currentPage];
}

class MovieLoaded extends MovieState {
  final List<MovieDto> movies;
  final bool hasReachedMax;
  final int currentPage;
  final int totalPages;

  MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [movies, hasReachedMax, currentPage, totalPages];
}

class MovieError extends MovieState {
  final String message;

  MovieError({required this.message});

  @override
  List<Object?> get props => [message];
}
