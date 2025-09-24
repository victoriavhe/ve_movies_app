import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';
import 'package:ve_movies_app/app/presentation/views/see_all/see_all_screen.dart';

class SeeAllView extends StatelessWidget {
  const SeeAllView({super.key, required this.title, required this.category});

  final String title;
  final MovieCategory category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<MovieBloc>(),
      child: SeeAllScreen(title: title, category: category),
    );
  }
}
