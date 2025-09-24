import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api_impl.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';
import 'package:ve_movies_app/app/presentation/views/see_all/see_all_view.dart';
import 'package:ve_movies_app/app/presentation/widgets/card/feature_card.dart';
import 'package:ve_movies_app/app/presentation/widgets/card/movie_card.dart';
import 'package:ve_movies_app/app/presentation/widgets/search/search_icon.dart';

import 'package:ve_movies_app/app/domain/usecase/movie_use_case.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc popularBloc;
  late MovieBloc topRatedBloc;
  late MovieBloc nowPlayingBloc;

  @override
  void initState() {
    super.initState();
    final usecase = sl<GetMoviesUsecase>();

    popularBloc = sl<MovieBloc>();
    topRatedBloc = sl<MovieBloc>();
    nowPlayingBloc = sl<MovieBloc>();

    popularBloc = MovieBloc(getMoviesUsecase: usecase);
    topRatedBloc = MovieBloc(getMoviesUsecase: usecase);
    nowPlayingBloc = MovieBloc(getMoviesUsecase: usecase);

    // Load initial data for each category
    popularBloc.add(LoadMovies(category: MovieCategory.popular));
    topRatedBloc.add(LoadMovies(category: MovieCategory.topRated));
    nowPlayingBloc.add(LoadMovies(category: MovieCategory.nowPlaying));
  }

  @override
  void dispose() {
    popularBloc.close();
    topRatedBloc.close();
    nowPlayingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section using SliverToBoxAdapter
          SliverToBoxAdapter(child: _buildHeroSection()),

          // Content Sections
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 12),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieSection(
                    "Trending Now",
                    popularBloc,
                    MovieCategory.popular,
                  ),
                  SizedBox(height: 20),
                  _buildMovieSection(
                    "Top Rated",
                    topRatedBloc,
                    MovieCategory.topRated,
                  ),
                  SizedBox(height: 20),
                  _buildMovieSection(
                    "Now Playing",
                    nowPlayingBloc,
                    MovieCategory.nowPlaying,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeroSection() {
    final h = MediaQuery.of(context).size.height * .7;

    return BlocBuilder<MovieBloc, MovieState>(
      bloc: popularBloc,
      builder: (context, state) {
        MovieDto? featuredMovie;

        if (state is MovieLoaded && state.movies.isNotEmpty) {
          featuredMovie = state.movies.first;
        }

        return Container(
          width: double.infinity,
          height: h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE6A500), Color(0xFFB8860B), Colors.black],
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                MovieApiImpl.getPosterUrl(featuredMovie?.posterPath),
              ),
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black54.withOpacity(.5),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    SearchIcon(),
                    FeatureCard(featuredMovie: featuredMovie),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieSection(
    String title,
    MovieBloc bloc,
    MovieCategory category,
  ) {
    return BlocBuilder<MovieBloc, MovieState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is MovieLoading) {
          return _buildLoadingSection(title);
        }

        if (state is MovieError) {
          return _buildErrorSection(title, state.message, () {
            bloc.add(LoadMovies(category: category));
          });
        }

        if (state is MovieLoaded) {
          return _buildSection(title, state.movies, category);
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget _buildSection(
    String title,
    List<MovieDto> movies,
    MovieCategory category,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SeeAllView(title: title, category: category),
                    ),
                  );
                },
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.take(10).length, // Show first 10 movies
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: MovieCard(movie: movies[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Container(
                    width: 133,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection(String title, String error, VoidCallback onRetry) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load movies',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(onPressed: onRetry, child: Text('Retry')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 80,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.search, false),
          _buildNavItem(Icons.download_outlined, false),
          _buildNavItem(Icons.menu, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 28);
  }
}
