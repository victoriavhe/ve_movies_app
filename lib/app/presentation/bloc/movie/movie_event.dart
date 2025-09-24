part of 'movie_bloc.dart';

enum MovieCategory { popular, topRated, nowPlaying, upcoming }

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends MovieEvent {
  final MovieCategory category;
  final int page;

  const LoadMovies({required this.category, this.page = 1});

  @override
  List<Object> get props => [category, page];
}

class LoadMoreMovies extends MovieEvent {
  final MovieCategory category;

  const LoadMoreMovies({required this.category});

  @override
  List<Object> get props => [category];
}

class RefreshMovies extends MovieEvent {
  final MovieCategory category;

  const RefreshMovies({required this.category});

  @override
  List<Object> get props => [category];
}

class SearchMovies extends MovieEvent {
  final String query;
  final int page;

  const SearchMovies({required this.query, this.page = 1});

  @override
  List<Object> get props => [query, page];
}