import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/movie.dart';
import '../models/tv.dart';
import '../models/user_flashr.dart';

class SearchService {
  SupabaseClient client = Supabase.instance.client;

  static Future<List<Movie>> fetchMoviesSearch(String searchTerm) async {
    if(searchTerm.isEmpty){
      return [];
    }
    final response = await Supabase.instance.client.functions.invoke('searchForMovie', body: {'search':searchTerm, 'page': 1});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Tv>> fetchTvsSearch(String searchTerm) async {
    final response = await Supabase.instance.client.functions.invoke('searchForTv', body: {'search':searchTerm, 'page': 1});
    if (response.status == 200) {
      var data = response.data;
      List result = data;
      return result.map((e) => Tv.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<UserFlashr>> fetchFriendsSearch(String searchTerm) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int user_id = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "search_for_friend",
          params: {"user_id": user_id, "input": searchTerm});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => UserFlashr.fromJson(e)).toList();
      } else {
        return [];
      }
    }else {
      throw Exception('Failed to get uuid');
    }
  }
}