class Group {
  final int id;
  final int creatorId;
  final String name;
  final String? iconPath;

  const Group({
     required this.id, required this.creatorId, required this.name, this.iconPath

  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id']?.toInt() ?? 0,
      name: json['name']?? '',
      creatorId: json['creator_id']?.toInt() ?? 0,
      iconPath: json['icon_path'] ?? '',

    );
  }
}