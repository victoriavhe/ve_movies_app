import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/domain/usecase/movie_use_case.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUsecase getMoviesUsecase;

  MovieBloc({required this.getMoviesUsecase}) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<RefreshMovies>(_onRefreshMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    final result = await getMoviesUsecase.call(
      GetMoviesParams(category: event.category, page: event.page),
    );
    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieResponse) => emit(
        MovieLoaded(
          movies: movieResponse.results ?? [],
          hasReachedMax: event.page >= movieResponse.totalPages!,
          currentPage: event.page,
          totalPages: movieResponse.totalPages!,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MovieState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieLoaded && !currentState.hasReachedMax) {
      emit(
        MovieLoadingMore(
          movies: currentState.movies,
          currentPage: currentState.currentPage,
        ),
      );
      final nextPage = currentState.currentPage + 1;
      final result = await getMoviesUsecase.call(
        GetMoviesParams(category: event.category, page: nextPage),
      );
      result.fold(
        (failure) => emit(MovieError(message: failure.message)),
        (movieResponse) => emit(
          MovieLoaded(
            movies: currentState.movies + movieResponse.results!,
            hasReachedMax: nextPage >= movieResponse.totalPages!,
            currentPage: nextPage,
            totalPages: movieResponse.totalPages!,
          ),
        ),
      );
    }
  }

  Future<void> _onRefreshMovies(
    RefreshMovies event,
    Emitter<MovieState> emit,
  ) async {
    final result = await getMoviesUsecase.call(
      GetMoviesParams(category: event.category, page: 1),
    );
    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieResponse) => emit(
        MovieLoaded(
          movies: movieResponse.results!,
          hasReachedMax: 1 >= movieResponse.totalPages!,
          currentPage: 1,
          totalPages: movieResponse.totalPages!,
        ),
      ),
    );
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading());
    final result = await getMoviesUsecase.call(
      GetMoviesParams(query: event.query, page: event.page),
    );
    result.fold(
      (failure) => emit(MovieError(message: failure.message)),
      (movieResponse) => emit(
        MovieLoaded(
          movies: movieResponse.results!,
          hasReachedMax: event.page >= movieResponse.totalPages!,
          currentPage: event.page,
          totalPages: movieResponse.totalPages!,
        ),
      ),
    );
  }
}
