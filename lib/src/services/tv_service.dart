import 'dart:convert';

import 'package:flasher_ui/src/models/tv_extra.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tv.dart';

class TvService {
    SupabaseClient client = Supabase.instance.client;


    static Future<List<Tv>> fetchTvsTrending(bool daily) async {
      final response =
      await Supabase.instance.client.functions.invoke('getTrendingTVs');
      if (response.status == 200) {
        var data = response.data;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load trending tvs');
      }
    }

    static Future<List<Tv>> fetchTvRecommendation() async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      int user_id = await SupabaseAuthService().getUserId(uuid!);
      List<int> users = [];
      users.add(user_id);
      final response = await Supabase.instance.client.functions
          .invoke('getTvRecommendation', body: {'user_ids': users, 'index': 2});
      if (response.status == 200) {
        var data = response.data;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load tv recommendation');
      }
    }

    static Future<List<Tv>> fetchSwipeTvRecommendation(int tvCount) async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      int userId = await SupabaseAuthService().getUserId(uuid!);
      final response = await Supabase.instance.client.functions.invoke(
          'getSwipeRecommendationsMovie',
          body: {'user_id': userId, 'tv_count': tvCount});
      if (response.status == 200) {
        var data = response.data;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load swipe tv recommendation');
      }
    }
    static Future<List<Tv>> fetchTvWatchlist() async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      if (uuid != null) {
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc(
            "get_liked_tvs_of_user",
            params: { "user_id": userId,});
        if (response != null) {
          var data = response;
          List result = data;
          return result.map((e) => Tv.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<List<Tv>> fetchRecentlyWatchedTvs() async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      if (uuid != null) {
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc(
            "get_recently_watched_tvs",
            params: { "user_id": userId,});
        if (response != null) {
          var data = response;
          List result = data;
          return result.map((e) => Tv.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<List<Tv>> fetchTvsOfActor(int actorId) async {
      final response = await Supabase.instance.client.functions.invoke(
          'getMoviesForActor',
          body: {'actor_id': actorId});
      if (response.status == 200) {
        var data = response.data;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load swipe movie recommendation');
      }
    }

    static Future<void> setTVStatusWatched(int tvId) async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      if (uuid != null) {
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc(
            "tv_status_watched",
            params: { "user_id": userId, "movie_id": tvId});
        if (response['status'] != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusInterested(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_interested", params: { "user_id": userId, "movie_id": tvId});
        if (response['status'] != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusUninterested(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int userId= await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_uninterested", params: { "user_id": userId, "movie_id": tvId});
        if (response['status'] != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> removeTVStatus(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_remove", params: { "user_id": userId, "movie_id": tvId});
        if (response['status'] != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusFavorite(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int userId = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_favorite", params: { "user_id": userId, "movie_id": tvId});
        if (response['status'] != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<List<Tv>> fetchTVWatchlistOfFriend(int userId) async {
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_liked_tvs_of_user",
          params: { "user_id": userId,});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        return [];
      }
    }

    static Future<List<Tv>> fetchRecentlyWatchedTVsOfFriend(
        int userId) async {
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_recently_watched_movies",
          params: { "user_id": userId,});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Tv.fromJson(e)).toList();
      } else {
        return [];
      }
    }

    static Future<List<TvExtra>> getExtraMovieInfo(int movieId) async {
      final response = await Supabase.instance.client.functions.invoke(
          'getExtraInfoMovie',
          body: {'movie_id': movieId}
      );

      if (response.status == 200) {
        // Da die Response keine Liste, sondern ein einzelnes Map enthält
        var data = response.data is String ? jsonDecode(response.data) as Map<String, dynamic> : response.data as Map<String, dynamic>;

        List<TvExtra> movieExtras = [];

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

          // Create MovieExtra object with the extracted data
          movieExtras.add(TvExtra(
            runtime: data['runtime'] as int? ?? 0,
            releaseDate: data['release_date'] as String? ?? '',
            watchProviderLink: watchProviderLink,
            flatrate: flatrateList,
          ));
        } catch (e) {
          // Handle parsing errors (log or throw a more specific exception)
          print('Error parsing movie details: $e');
          print('Movie Item: $data');
        }

        return movieExtras;
      } else {
        throw Exception('Unexpected response format from Supabase function');
      }
    }
}