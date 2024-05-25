import 'package:flasher_ui/src/models/media_extra.dart';

class MovieExtra implements MediaExtra {
  final int runtime;
  final String releaseDate;
  final String watchProviderLink;
  final List<Map<String, dynamic>>? flatrate; // Optional, falls flatrate manchmal fehlt

  MovieExtra({
    required this.runtime,
    required this.releaseDate,
    required this.watchProviderLink,
    this.flatrate,
  });

  factory MovieExtra.fromJson(Map<String, dynamic> json) {
    final watchProvider = json['watch_provider'] as Map<String, dynamic>?;

    return MovieExtra(
      runtime: json['runtime'] as int? ?? 0,
      releaseDate: json['release_date'] as String? ?? '',
      watchProviderLink: watchProvider?['link'] ?? '',
      flatrate: watchProvider != null && watchProvider['flatrate'] != null && watchProvider['flatrate'].isNotEmpty
          ? List<Map<String, dynamic>>.from(watchProvider['flatrate'].map((item) => item as Map<String, dynamic>))
          : null,
    );
  }
}