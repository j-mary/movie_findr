import 'package:flutter/material.dart';
import 'package:movie_findr/core/utils/constants.dart';

import '../../../core/models/genre.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.genre,
    required this.onTap,
  });

  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Material(
        color: genre.isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(kBorderRadius),
          onTap: onTap,
          child: Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              genre.name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
