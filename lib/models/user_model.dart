class UserModel {
  String uid;
  String? nickname;

  UserModel({
    required this.uid,
    this.nickname,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      nickname: map['nickname'],
    );
  }
}
