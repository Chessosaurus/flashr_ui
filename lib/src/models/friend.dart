class Friend {
  final int friendId;
  final String friendName;

  Friend({required this.friendId, required this.friendName});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friendId: json['friend_id']?.toInt() ?? 0,
      friendName: json['friend_name'] ?? '',
    );
  }
}