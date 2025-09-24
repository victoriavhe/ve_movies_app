import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';
import 'package:ve_movies_app/app/presentation/views/home/home_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieBloc>(),
      child: HomeScreen(),
    );
  }
}
