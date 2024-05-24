class MovieExtra {
  final int runtime;
  final String releaseDate;
  final String watchProviderLink;
  final Map<String, dynamic>? flatrate; // Optional, falls flatrate manchmal fehlt

  MovieExtra({
    required this.runtime,
    required this.releaseDate,
    required this.watchProviderLink,
    this.flatrate,
  });

  factory MovieExtra.fromJson(Map<String, dynamic> json) {
    final watchProvider = json['watch_provider'] as Map<String, dynamic>?;

    return MovieExtra(
      runtime: json['runtime'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      watchProviderLink: watchProvider?['link'] ?? '',
      flatrate: watchProvider != null && watchProvider['flatrate'] != null && watchProvider['flatrate'].isNotEmpty
          ? (watchProvider['flatrate'][0] as Map<String, dynamic>) // Access the first element of the array
          : null,
    );
  }
}