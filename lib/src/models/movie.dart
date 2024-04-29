class Movie {
  final int id;

  const Movie({
    required this.id
});

  factory Movie.fromJson(Map<int, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      } =>
          Movie(
            id: id,
          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}