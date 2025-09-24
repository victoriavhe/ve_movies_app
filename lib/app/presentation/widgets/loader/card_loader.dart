import 'package:flutter/material.dart';

class CardLoader extends StatelessWidget {
  const CardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          strokeWidth: 2,
        ),
      ),
    );
  }
}
