import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/friend.dart';

class FriendsService {
  SupabaseClient client = Supabase.instance.client;

  static Future<void> acceptFriendship(int? friendId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "user_friendship_accept",
          params: { "friend_0": userId , "friend_1":friendId});
      if (response['status'] != 200) {
        throw Exception('Failed to create group');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> removeFriendship(int? friendId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "user_friendship_remove",
          params: { "friend_0": userId, "friend_1": friendId});
      if (response['status'] != 200) {
        throw Exception('Failed to ');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> requestFriendship(int? friendId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "user_friendship_request",
          params: { "friend_0": userId, "friend_1": friendId});
      if (response['status'] != 200) {
        throw Exception('Failed to send request');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Friend>> getFriendsOfUser() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_friends_of_user",
          params: { "user_id": userId});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Friend.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<List<Friend>> getFriendshipRequests() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_friendship_requests",
          params: { "user_id": userId});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Friend.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }


}