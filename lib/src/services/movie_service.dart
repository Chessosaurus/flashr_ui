import 'dart:convert';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie.dart';
import '../models/tv.dart';

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

  static Future<List<Tv>> fetchTvsTrending(bool daily) async {
    final response =
    await Supabase.instance.client.functions.invoke('getTrendingTVs');
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Tv.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  static Future<List<Movie>> fetchMovieRecommendation() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    int user_id = await SupabaseAuthService().getUserId(uuid!);
    final response = await Supabase.instance.client.functions
        .invoke('getMovieRecommendation', body: {'user_id': user_id});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movie recommendation');
    }
  }

  static Future<List<Tv>> fetchTvRecommendation() async {
    final response = await Supabase.instance.client.functions
        .invoke('getTvRecommendation');
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Tv.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movie recommendation');
    }
  }



  static Future<List<Movie>> fetchSwipeMovieRecommendation(int movieCount) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    int user_id = await SupabaseAuthService().getUserId(uuid!);
    final response = await Supabase.instance.client.functions.invoke(
        'getSwipeRecommendationsMovie',
        body: {'user_id': user_id, 'movie_count': movieCount});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load swipe movie recommendation');
    }
  }

  static Future<List<Tv>> fetchSwipeTvRecommendation(int tvCount) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    final response = await Supabase.instance.client.functions.invoke(
        'getSwipeRecommendationsMovie',
        body: {'user_id': uuid, 'tv_count': tvCount});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Tv.fromJson(e)).toList();
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
    }else {
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
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "movie_status_watched",
          params: { "user_id": user_id, "movie_id": movieId});
      if (response.status != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> setMovieStatusInterested(int movieId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("movie_status_interested", params: { "user_id": user_id, "movie_id": movieId});
        if (response != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
  }

  static Future<void> setMovieStatusUninterested(int movieId) async{
    String? uuid = SupabaseAuthService().user?.userUuid;
    if(uuid != null){
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc("movie_status_uninterested", params: { "user_id": user_id, "movie_id": movieId});
      if (response.status != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> removeMovieStatus(int movieId) async{
    String? uuid = SupabaseAuthService().user?.userUuid;
    if(uuid != null){
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc("movie_status_remove", params: { "user_id": user_id, "movie_id": movieId});
      if (response.status != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> setMovieStatusFavorite(int movieId) async{
    String? uuid = SupabaseAuthService().user?.userUuid;
    if(uuid != null){
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc("movie_status_favorite", params: { "user_id": user_id, "movie_id": movieId});
      if (response.status != 200) {
        throw Exception('Failed to set movie status');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

}




