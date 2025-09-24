import 'package:flutter/material.dart';
import 'package:ve_movies_app/app/presentation/widgets/loader/card_loader.dart';

class CardLoaderGrid extends StatelessWidget {
  const CardLoaderGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: .7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: 12,
      itemBuilder: (context, index) => CardLoader(),
    );
  }
}
