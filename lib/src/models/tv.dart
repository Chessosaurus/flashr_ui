import 'media.dart';

class Tv implements Media {
  final String posterPath;
  final int id;
  final List<int>? genreIds;
  final String title;
  final double voteAverage;
  final String overview;
  final String releaseDate;


  const Tv({
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.id,
    this.genreIds,
    required this.title,
    required this.releaseDate,
  });


  factory Tv.fromJson(Map<String, dynamic> json) {
    return Tv(
      posterPath: json['poster_path'] ?? '',
      id: json['id']?.toInt() ?? 0,
      //genreIds: json['genre_ids'].cast<int>(),
      title: json['title'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'poster_path': posterPath,
      'id': id,
      'genre_ids': genreIds,
      'title': title,
      'vote_average': voteAverage,
      'overview': overview,
      'release_date': releaseDate,
    };
  }

  @override
  List<Object?> get props => [id, title];

  @override
  bool? get stringify => true;

}