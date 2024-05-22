import 'package:flasher_ui/src/services/supabase_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}