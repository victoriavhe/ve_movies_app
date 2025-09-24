import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ve_movies_app/app/domain/repository/movie_repository.dart';
import 'package:ve_movies_app/app/domain/usecase/movie_use_case.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api_impl.dart';
import 'package:ve_movies_app/app/infra/repo/movie_repository_impl.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // Http client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // API
  sl.registerLazySingleton<MovieApi>(() => MovieApiImpl());

  // Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(movieApi: sl()),
  );

  // UseCase
  sl.registerLazySingleton<GetMoviesUsecase>(
    () => GetMoviesUsecase(repository: sl()),
  );

  // Bloc → factory, so each call gives you a fresh bloc instance
  sl.registerFactory<MovieBloc>(() => MovieBloc(getMoviesUsecase: sl()));
}
