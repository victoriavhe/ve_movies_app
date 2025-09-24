import 'package:flutter/material.dart';
import 'package:ve_movies_app/app/presentation/views/search/search_view.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchView()),
              );
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
