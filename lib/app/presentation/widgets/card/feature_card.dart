import 'package:flutter/material.dart';
import 'package:ve_movies_app/app/infra/dto/movie_response_dto.dart';
import 'package:ve_movies_app/app/presentation/widgets/show_movie_details.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.featuredMovie});

  final MovieDto? featuredMovie;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (featuredMovie?.posterPath == null)
            // Fallback placeholder
            Container(
              height: 200,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.movie, size: 80, color: Colors.black87),
              ),
            ),

          SizedBox(height: 30),

          // Featured Movie Title
          if (featuredMovie != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                featuredMovie?.title?.toUpperCase() ?? '',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Text(
              'FEATURED MOVIE',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),

          SizedBox(height: 8),

          // Rating
          if (featuredMovie != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 20),
                SizedBox(width: 4),
                Text(
                  featuredMovie?.voteAverage?.toStringAsFixed(1) ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          SizedBox(height: 30),

          // Action Buttons
          OutlinedButton(
            onPressed: () {
              if (featuredMovie != null) {
                showMovieDetails(featuredMovie!, context);
              }
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
