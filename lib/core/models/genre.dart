import 'package:flutter/foundation.dart';
import 'package:movie_flow/core/entities/genre_entity.dart';

@immutable
class Genre {
  final int id;
  final String name;
  final bool isSelected;

  const Genre({
    this.id = 0,
    required this.name,
    this.isSelected = false,
  });

  factory Genre.fromEntity(GenreEntity entity) =>
      Genre(name: entity.name, id: entity.id, isSelected: false);

  Genre toggleSelected() {
    return Genre(
      id: id,
      name: name,
      isSelected: !isSelected,
    );
  }

  const Genre.initial()
      : id = 0,
        name = 'name',
        isSelected = false;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isSelected': isSelected,
    };
  }

  @override
  String toString() => '${toMap()}';
}
