import 'package:flutter/material.dart';
import 'package:ve_movies_app/app/infra/api/movie/movie_api_impl.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';

void showMovieDetails(MovieDto movie, BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _buildMovieDetailsSheet(movie, context),
  );
}

Widget _buildMovieDetailsSheet(MovieDto movie, context) {
  final h = MediaQuery.of(context).size.height * .7;

  return Container(
    height: h,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      children: [
        // Handle
        Container(
          width: 40,
          height: 4,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poster
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: movie.posterPath != null
                            ? Image.network(
                          MovieApiImpl.getPosterUrl(movie.posterPath),
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.movie, color: Colors.white54),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text(
                                movie.voteAverage?.toStringAsFixed(1) ?? '',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 16),
                              Text(
                                movie.releaseDate?.toString().split(' ')[0] ?? '',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.play_arrow),
                                  label: Text('Play'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.add, color: Colors.white),
                                style: IconButton.styleFrom(
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Overview
                Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  movie.overview ?? 'No overview available.',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}