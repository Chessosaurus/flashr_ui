import 'friend.dart';

class UserFlashr {
  final String? userUuid;
  final  int? userId;
  final String? username;
  final String? email;
  final List<Friend>? friends;

  UserFlashr({
    required this.userUuid, this.username, required this.email, this.userId, this.friends
  });

  set userId(int? id){
    userId = id;
  }

  factory UserFlashr.fromJson(Map<String, dynamic> json) {
    return UserFlashr(
      userUuid: json['user_uuid'] ?? '',
      userId: json['id']?.toInt() ?? 0,
      username: json['user_name'] ?? '',
      email: '',
      //friends: json['friends'] ?? '',
    );
  }

}