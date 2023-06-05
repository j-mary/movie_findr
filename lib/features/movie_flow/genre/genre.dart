import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Genre {
  final String name;
  final bool? isSelected;
  final int? id;

  const Genre({
    required this.name,
    this.isSelected = false,
    this.id = 0,
  });

  Genre toggleSelected() {
    return Genre(
      name: name,
      isSelected: !isSelected!,
      id: id,
    );
  }

  Genre copyWith({
    String? name,
    bool? isSelected,
    int? id,
  }) {
    return Genre(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isSelected': isSelected,
      'id': id,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      name: map['name'] ?? '',
      isSelected: map['isSelected'],
      id: map['id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) => Genre.fromMap(json.decode(source));

  @override
  String toString() => 'Genre(name: $name, isSelected: $isSelected, id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Genre &&
        other.name == name &&
        other.isSelected == isSelected &&
        other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ isSelected.hashCode ^ id.hashCode;
}
