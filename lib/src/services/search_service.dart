import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/movie.dart';
import '../models/tv.dart';

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
}