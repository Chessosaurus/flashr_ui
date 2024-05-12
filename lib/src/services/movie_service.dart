import 'dart:convert';
import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/movie.dart';

class MovieService {
  SupabaseClient client = Supabase.instance.client;

  static Future<List<Movie>> fetchMoviesTrending(bool daily) async {
    final response =
        await Supabase.instance.client.functions.invoke('getTrendingMovies');
    if (response.status == 200) {
      var data = response.data;
      List result = data["results"];
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
    //return daily ? _fetchMoveisTrendingDaily() : _fetchMoviesTrendingWeekly();
  }

  static Future<List<Movie>> fetchMovieRecommendation() async {
    final response = await Supabase.instance.client.functions
        .invoke('getMovieRecommendation');
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movie recommendation');
    }
  }

  static Future<List<Movie>> fetchSwipeMovieRecommendation(
      int movieCount) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    final response = await Supabase.instance.client.functions.invoke(
        'getSwipeRecommendationsMovie',
        body: {'user_id': uuid, 'movie_count': movieCount});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load swipe movie recommendation');
    }
  }
}

/*
  static Future<List<Movie>> _fetchMoviesTrendingWeekly() async {
    final response = await Supabase.instance.client.functions.invoke('getTrendingMovies');
  }

  static Future<List<Movie>> _fetchMoviesTrendingDaily() async {

  }
*/
