import 'dart:convert';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie.dart';
import '../models/movie_extra.dart';

class MovieService {
  SupabaseClient client = Supabase.instance.client;

  static Future<List<Movie>> fetchMoviesTrending(bool daily) async {
    final response =
    await Supabase.instance.client.functions.invoke('getTrendingMovies');
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  static Future<List<Movie>> fetchMovieRecommendation() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    int user_id = await SupabaseAuthService().getUserId(uuid!);
    List<int> users = [];
    users.add(user_id);
    final response = await Supabase.instance.client.functions
        .invoke(
        'getMovieRecommendation', body: {'user_ids': users, 'index': 2});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movie recommendation');
    }
  }

  static Future<List<Movie>> fetchSwipeMovieRecommendation(int movieCount) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    int userId = await SupabaseAuthService().getUserId(uuid!);
    final response = await Supabase.instance.client.functions.invoke(
        'getSwipeRecommendationsMovie',
        body: {'user_id': userId, 'movie_count': movieCount});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load swipe movie recommendation');
    }
  }

  static Future<List<Movie>> fetchMovieWatchlist() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_liked_movies_of_user",
          params: { "user_id": user_id,});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Movie.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Movie>> fetchMovieFavorite() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_favorite_movies_of_user",
          params: { "user_id": user_id,});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Movie.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Movie>> fetchRecentlyWatchedMovies() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_recently_watched_movies",
          params: { "user_id": userId,});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Movie.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Movie>> fetchMoviesOfActor(int actorId) async {
    final response = await Supabase.instance.client.functions.invoke(
        'getMoviesForActor',
        body: {'actor_id': actorId});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load swipe movie recommendation');
    }
  }

  static Future<void> setMovieStatusWatched(int movieId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "movie_status_watched",
          params: { "user_id": userId, "movie_id": movieId});
      if (response['status'] != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> setMovieStatusInterested(int movieId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "movie_status_interested",
          params: { "user_id": userId, "movie_id": movieId});
      if (response['status'] != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> setMovieStatusUninterested(int movieId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "movie_status_uninterested",
          params: { "user_id": user_id, "movie_id": movieId});
      if (response['status'] != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> removeMovieStatus(int movieId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "movie_status_remove",
          params: { "user_id": userId, "movie_id": movieId});
      if (response['status'] != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> setMovieStatusFavorite(int movieId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc("movie_status_favorite", params: { "user_id": userId, "movie_id": movieId});
      if (response['status'] != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Movie>> fetchMovieWatchlistofFriend(int userId) async {
    final response = await Supabase.instance.client.schema("persistence").rpc(
        "get_liked_movies_of_user",
        params: { "user_id": userId,});
    if (response != null) {
      var data = response;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<Movie>> fetchRecentlyWatchedMoviesofFriend(
      int userId) async {
    final response = await Supabase.instance.client.schema("persistence").rpc(
        "get_recently_watched_movies",
        params: { "user_id": userId,});
    if (response != null) {
      var data = response;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<Movie>> fetchFavoriteMoviesOfFriend(int userId) async {
    final response = await Supabase.instance.client.schema("persistence").rpc(
        "get_favorite_movies_of_user",
        params: { "user_id": userId,});
    if (response != null) {
      var data = response;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<MovieExtra> getExtraMovieInfo(int movieId) async {
    final response = await Supabase.instance.client.functions.invoke(
        'getExtraInfoMovie',
        body: {'movie_id': movieId}
    );

    if (response.status == 200) {
      // Da die Response keine Liste, sondern ein einzelnes Map enthält
      var data = response.data is String ? jsonDecode(response.data) as Map<String, dynamic> : response.data as Map<String, dynamic>;

      List<MovieExtra> movieExtras = [];

      try {
        // Extract and process watch_provider data
        final watchProvider = data['watch_provider'] as Map<String, dynamic>?;
        final watchProviderLink = watchProvider?['link'] ?? '';
        List<Map<String, dynamic>>? flatrateList = null;
         if (watchProvider != null && watchProvider['flatrate'] != null &&
            (watchProvider['flatrate'] as List).isNotEmpty) {
          flatrateList =
          List<Map<String, dynamic>>.from(watchProvider['flatrate']);
        }


        final movieExtra = MovieExtra(
          runtime: data['runtime'] as int? ?? 0,
          releaseDate: data['release_date'] as String? ?? '',
          watchProviderLink: watchProviderLink,
          flatrate: flatrateList,
        );
        return movieExtra;
      } catch (e) {
        // Handle parsing errors (log or throw a more specific exception)
        print('Error parsing movie details: $e');
        print('Movie Item: $data');
        rethrow;
      }
    } else {
      throw Exception('Unexpected response format from Supabase function');
    }
  }
}




