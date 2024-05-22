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
        throw Exception('Failed to load trending movies');
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

    static Future<void> setTVStatusWatched(int tvId) async {
      String? uuid = SupabaseAuthService().user?.userUuid;
      if (uuid != null) {
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc(
            "tv_status_watched",
            params: { "user_id": user_id, "movie_id": tvId});
        if (response.status != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusInterested(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_interested", params: { "user_id": user_id, "movie_id": tvId});
        if (response != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusUninterested(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_uninterested", params: { "user_id": user_id, "movie_id": tvId});
        if (response.status != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> removeTVStatus(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_remove", params: { "user_id": user_id, "movie_id": tvId});
        if (response.status != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }

    static Future<void> setTVStatusFavorite(int tvId) async{
      String? uuid = SupabaseAuthService().user?.userUuid;
      if(uuid != null){
        int user_id = await SupabaseAuthService().getUserId(uuid);
        final response = await Supabase.instance.client.schema("persistence").rpc("tv_status_favorite", params: { "user_id": user_id, "movie_id": tvId});
        if (response.status != 200) {
          throw Exception('Failed to set movie status');
        }
      } else {
        throw Exception('Failed to get uuid');
      }
    }
}