import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.filledBackground = false,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final bool filledBackground;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      style: filledBackground
          ? IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
            )
          : null,
      icon: Icon(
        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
        color: isFavorite ? Colors.pink.shade600 : Colors.grey.shade800,
      ),
    );
  }
}
