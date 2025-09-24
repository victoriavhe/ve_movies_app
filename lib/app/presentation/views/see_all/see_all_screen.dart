import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/bloc/movie/movie_bloc.dart';
import 'package:ve_movies_app/app/presentation/widgets/card/movie_card.dart';
import 'package:ve_movies_app/app/presentation/widgets/loader/card_loader.dart';
import 'package:ve_movies_app/app/presentation/widgets/loader/card_loader_grid.dart';

class SeeAllScreen extends StatefulWidget {
  final String title;
  final MovieCategory category;

  const SeeAllScreen({super.key, required this.title, required this.category});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late MovieBloc movieBloc;
  late MovieBloc searchBloc;

  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  List<MovieDto> _filteredMovies = [];
  String _selectedFilter = "All";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    movieBloc = sl<MovieBloc>();
    searchBloc = sl<MovieBloc>();

    movieBloc.add(LoadMovies(category: widget.category));
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    movieBloc.close();
    searchBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !_isSearching) {
      movieBloc.add(LoadMoreMovies(category: widget.category));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (query.isNotEmpty) {
      if (!_isSearching) {
        setState(() {
          _isSearching = true;
        });
      }

      // Debounce search
      Future.delayed(Duration(milliseconds: 500), () {
        if (_searchController.text.trim() == query && query.isNotEmpty) {
          searchBloc.add(SearchMovies(query: query));
        }
      });
    } else {
      setState(() {
        _isSearching = false;
        _filteredMovies = [];
      });
    }
  }

  void _filterMovies(List<MovieDto> movies) {
    switch (_selectedFilter) {
      case "All":
        _filteredMovies = movies;
        break;
      case "High Rated":
        _filteredMovies =
            movies.where((movie) => movie.voteAverage! >= 7.0).toList();
        break;
      case "Recent":
        _filteredMovies =
            movies.where((movie) {
              if (movie.releaseDate == null) return false;
              final releaseYear =
                  int.tryParse(movie.releaseDate!.toString().substring(0, 4)) ??
                  0;
              return releaseYear >= DateTime.now().year - 2;
            }).toList();
        break;
      case "Popular":
        _filteredMovies =
            movies.where((movie) => movie.voteCount! > 1000).toList();
        break;
      default:
        _filteredMovies = movies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            _buildResultsCount(),

            SizedBox(height: 16),

            Expanded(child: _buildMoviesGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.search, color: Colors.white, size: 28),
            ],
          ),

          SizedBox(height: 16),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search ${widget.title.toLowerCase()}...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[400]),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _isSearching = false;
                              _filteredMovies = [];
                            });
                          },
                        )
                        : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("All"),
                SizedBox(width: 8),
                _buildFilterChip("High Rated"),
                SizedBox(width: 8),
                _buildFilterChip("Recent"),
                SizedBox(width: 8),
                _buildFilterChip("Popular"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount() {
    return BlocBuilder<MovieBloc, MovieState>(
      bloc: _isSearching ? searchBloc : movieBloc,
      builder: (context, state) {
        int count = 0;
        if (state is MovieLoaded) {
          count =
              _filteredMovies.isNotEmpty
                  ? _filteredMovies.length
                  : state.movies.length;
        } else if (state is MovieLoadingMore) {
          count = state.movies.length;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '$count titles',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              if (_isSearching) ...[
                SizedBox(width: 8),
                Icon(Icons.search, color: Colors.grey[600], size: 16),
              ],
              Spacer(),
              Icon(Icons.tune, color: Colors.grey[400]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoviesGrid() {
    return BlocBuilder<MovieBloc, MovieState>(
      bloc: _isSearching ? searchBloc : movieBloc,
      builder: (context, state) {
        if (state is MovieInitial || state is MovieLoading) {
          return CardLoaderGrid();
        }

        if (state is MovieError) {
          return _buildErrorState(state.message);
        }

        if (state is MovieLoaded || state is MovieLoadingMore) {
          List<MovieDto> movies;
          bool hasReachedMax = true;

          if (state is MovieLoaded) {
            movies = state.movies;
            hasReachedMax = state.hasReachedMax;
            // Apply filters when not searching
            if (!_isSearching && _filteredMovies.isEmpty) {
              _filterMovies(movies);
            }
          } else {
            movies = (state as MovieLoadingMore).movies;
            hasReachedMax = false;
          }

          final displayMovies =
              _isSearching
                  ? movies
                  : (_filteredMovies.isNotEmpty ? _filteredMovies : movies);

          if (displayMovies.isEmpty) {
            return _buildEmptyState();
          }

          return GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount:
                displayMovies.length +
                (!hasReachedMax && !_isSearching ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= displayMovies.length) {
                return CardLoader();
              }

              return MovieCard(movie: displayMovies[index]);
            },
          );
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });

        // Reapply filter to current movies
        final currentState = movieBloc.state;
        if (currentState is MovieLoaded) {
          _filterMovies(currentState.movies);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
          border:
              isSelected
                  ? Border.all(color: Colors.red.shade300, width: 1)
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.movie_filter,
            color: Colors.grey[600],
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            _isSearching ? 'No search results found' : 'No movies found',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _isSearching
                ? 'Try a different search term'
                : 'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          if (_isSearching) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                  _filteredMovies = [];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          SizedBox(height: 16),
          Text(
            'Error loading movies',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_isSearching) {
                searchBloc.add(SearchMovies(query: _searchController.text));
              } else {
                movieBloc.add(LoadMovies(category: widget.category));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
