import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ve_movies_app/app/core/di/service_locator.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api_impl.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/widgets/show_movie_details.dart';
import '../../bloc/movie/movie_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late MovieBloc _searchBloc;
  List<String> _searchHistory = [];
  bool _isSearchActive = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchBloc = sl<MovieBloc>();

    // TODO Load local
    _loadSearchHistory();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && _currentQuery.isNotEmpty) {
      //load more on search
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * .9);
  }

  void _loadSearchHistory() {
    //TODO load from SharedPreferences or local database
    setState(() {
      _searchHistory = [
        'Avengers',
        'Spider-Man',
        'The Dark Knight',
        'Inception',
        'Interstellar',
      ];
    });
  }

  void _addToSearchHistory(String query) {
    if (query.trim().isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.take(10).toList();
        }
      });
      // TODO save to SharedPreferences
    }
  }

  void _removeFromSearchHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      _addToSearchHistory(query);
      setState(() {
        _isSearchActive = true;
        _currentQuery = query;
      });
      _searchBloc.add(SearchMovies(query: query));
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
      _currentQuery = '';
    });
    // clear search on bloc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildSearchAppBar(),
      body: BlocProvider.value(
        value: _searchBloc,
        child: Column(
          children: [
            Expanded(
              child:
                  _isSearchActive
                      ? _buildSearchResults()
                      : _buildSearchSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: SizedBox(
        height: 45,
        child: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400]),
                      onPressed: _clearSearch,
                    )
                    : Icon(Icons.search, color: Colors.grey[400]),
          ),
          onSubmitted: _performSearch,
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Searches Section
          _buildPopularSearches(),

          SizedBox(height: 24),

          // Search History Section
          if (_searchHistory.isNotEmpty) _buildSearchHistory(),

          SizedBox(height: 24),

          // Trending Movies Section
          _buildTrendingMovies(),
        ],
      ),
    );
  }

  Widget _buildPopularSearches() {
    final popularSearches = [
      'Action Movies',
      'Comedy',
      'Horror',
      'Sci-Fi',
      'Romance',
      'Thriller',
      'Animation',
      'Documentary',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Searches',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              popularSearches.map((search) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: Text(
                      search,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _clearSearchHistory,
              child: Text(
                'Clear All',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...(_searchHistory
            .take(5)
            .map((query) => _buildHistoryItem(query))
            .toList()),
      ],
    );
  }

  Widget _buildHistoryItem(String query) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Icon(Icons.history, color: Colors.grey[400]),
      title: Text(query, style: TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: Icon(Icons.close, color: Colors.grey[400], size: 20),
        onPressed: () => _removeFromSearchHistory(query),
      ),
      onTap: () {
        _searchController.text = query;
        _performSearch(query);
      },
    );
  }

  Widget _buildTrendingMovies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...[
          'Spider-Man: No Way Home',
          'The Batman',
          'Doctor Strange',
          'Top Gun: Maverick',
          'Avatar: The Way of Water',
        ].map((movie) => _buildTrendingItem(movie)),
      ],
    );
  }

  Widget _buildTrendingItem(String movieTitle) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(Icons.movie, color: Colors.grey[400]),
      ),
      title: Text(
        movieTitle,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Trending',
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
      trailing: Icon(Icons.trending_up, color: Color(0xFFE6A500)),
      onTap: () {
        _searchController.text = movieTitle;
        _performSearch(movieTitle);
      },
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return _buildLoadingState();
        }

        if (state is MovieError) {
          return _buildErrorState(state.message);
        }

        if (state is MovieLoaded) {
          return _buildSearchResultsList(state.movies);
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFE6A500)),
          SizedBox(height: 16),
          Text(
            'Searching movies...',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 64),
          SizedBox(height: 16),
          Text(
            'Search failed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                () => _searchBloc.add(
                  SearchMovies(query: _searchController.text),
                ),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE6A500)),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.grey[600], size: 64),
          SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList(List<MovieDto> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Search Results (${movies.length})',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length + 1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (index >= movies.length) {
                return BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Color(0xFFE6A500),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                );
              }
              return _buildSearchResultItem(movies[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResultItem(MovieDto movie) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: Container(
          width: 60,
          height: 90,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                movie.posterPath != null
                    ? Image.network(
                      MovieApiImpl.getPosterUrl(movie.posterPath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.movie, color: Colors.grey[400]),
                        );
                      },
                    )
                    : Container(
                      color: Colors.grey[800],
                      child: Icon(Icons.movie, color: Colors.grey[400]),
                    ),
          ),
        ),
        title: Text(
          movie.title ?? '',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                SizedBox(width: 4),
                Text(
                  movie.voteAverage?.toStringAsFixed(1) ?? '0.0',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                SizedBox(width: 16),
                Text(
                  movie.releaseDate?.toString().split(' ')[0] ?? '',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              movie.overview ?? '',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          // Navigate to movie details
          showMovieDetails(movie, context);
        },
      ),
    );
  }
}
