import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/album.dart';
import '../models/movie.dart';

class Movieprovider {


  Future<Movie?> fetchMovies() async {
    //final data = await Supabase.instance.client.schema("persistence").from("Movie").select("*");
    try {
      //final user = await Supabase.instance.client.auth.currentUser;
      //final res = await Supabase.instance.client.schema("persistence").rpc("get_user_name", params: {"user_id": user?.id});
      final res = await Supabase.instance.client.schema("persistence").from(
          "Movie").select().eq("id", 1275091);
      final data = res.toString();
      return Movie.fromJson(res.asMap());
    } catch (error) {
      print(error);
      return null;
    }
  }

    Future<Album> fetchAlbum() async {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
}