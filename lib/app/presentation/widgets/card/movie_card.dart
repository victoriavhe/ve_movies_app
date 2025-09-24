import 'package:flutter/material.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api_impl.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/widgets/show_movie_details.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final MovieDto movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showMovieDetails(movie, context),
      child: Container(
        width: 133,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Movie Poster
              movie.posterPath != null
                  ? Image.network(
                    MovieApiImpl.getPosterUrl(movie.posterPath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie, color: Colors.white54, size: 40),
                            SizedBox(height: 8),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                movie.title ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                  : Container(
                    color: Colors.grey[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie, color: Colors.white54, size: 40),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            movie.title ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

              // Rating Badge
              if (movie.voteAverage! > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          movie.voteAverage! >= 7.0
                              ? Colors.green
                              : Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 8),
                        SizedBox(width: 2),
                        Text(
                          movie.voteAverage?.toStringAsFixed(1) ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Title Overlay
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    movie.title ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
