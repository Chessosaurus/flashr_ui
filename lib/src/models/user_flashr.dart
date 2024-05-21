class UserFlashr {
  final String userUuid;
  final  int? userId;
  final String? username;
  final String? email;

  UserFlashr({
    required this.userUuid, this.username, required this.email, this.userId
  });

  set userId(int? id){
    userId = id;
  }

}