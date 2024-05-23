import 'package:flasher_ui/src/models/user_flashr.dart';
import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/group.dart';

class GroupService {
  SupabaseClient client = Supabase.instance.client;

  static Future<void> createGroup(String groupName) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "create_group",
          params: { "user_id": userId, "group_name": groupName});
      if (response.status != 200) {
        throw Exception('Failed to create group');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> deleteGroup(int groupId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "create_group",
          params: { "user_id": userId, "group_id": groupId});
      if (response.status != 200) {
        throw Exception('Failed to create group');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }

  static Future<void> addUserToGroup(int groupId) async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "add_user_to_group",
          params: { "user_id": userId, "group_id": groupId});
      if (response.status != 200) {
        throw Exception('Failed to add User to group');
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }


  static Future<void> removeUserFromGroup(int groupId, int userId) async {
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "add_user_to_group",
          params: { "user_id": userId, "group_id": groupId});
      if (response.status != 200) {
        throw Exception('Failed to add User to group');
      }
  }


  static Future<List<Group>> getUsersGroups() async {
    String? uuid = SupabaseAuthService().user?.userUuid;
    if (uuid != null) {
      int userId = await SupabaseAuthService().getUserId(uuid);
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_users_groups",
          params: { "user_id": userId});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => Group.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to get uuid');
    }
  }


  static Future<List<UserFlashr>> getUsersOfGroup(int groupId) async {
      final response = await Supabase.instance.client.schema("persistence").rpc(
          "get_users_groups",
          params: { "groupd_id": groupId});
      if (response != null) {
        var data = response;
        List result = data;
        return result.map((e) => UserFlashr.fromJson(e)).toList();
      } else {
        return [];
      }
  }

}



