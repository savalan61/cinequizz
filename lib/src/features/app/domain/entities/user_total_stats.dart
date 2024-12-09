class UserTotalStats {
  UserTotalStats({
    required this.userId,
    required this.userName,
    required this.correctNo,
    required this.wrongNo,
    required this.avatarSeed,
  });
  factory UserTotalStats.fromMap(Map<String, dynamic> data) {
    return UserTotalStats(
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      avatarSeed: data['avatarSeed'] as String,
      correctNo: data['correctNo'] as int,
      wrongNo: data['wrongNo'] as int,
    );
  }
  final String userId;
  final String userName;
  final String avatarSeed;
  final int correctNo;
  final int wrongNo;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'correctNo': correctNo,
      'wrongNo': wrongNo,
      'avatarSeed': avatarSeed
    };
  }
}
