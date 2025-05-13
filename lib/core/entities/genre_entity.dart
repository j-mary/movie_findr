import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_findr/core/models/genre.dart';

// maps data from the api

@immutable
class GenreEntity extends Equatable {
  final String name;
  final int id;

  const GenreEntity({
    required this.name,
    this.id = 0,
  });

  GenreEntity copyWith({
    String? name,
    bool? isSelected,
    int? id,
  }) {
    return GenreEntity(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory GenreEntity.fromMap(Map<String, dynamic> map) {
    return GenreEntity(
      name: map['name'] ?? '',
      id: map['id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GenreEntity.fromJson(String source) =>
      GenreEntity.fromMap(json.decode(source));

  @override
  String toString() => '${toMap()}';

  @override
  List<Object> get props => [name, id];

  // used for test cases
  factory GenreEntity.fromGenre(Genre genre) =>
      GenreEntity(name: genre.name, id: genre.id);
}
