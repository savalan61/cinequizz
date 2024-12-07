import 'package:cloud_firestore/cloud_firestore.dart';

class UserStats {
  UserStats({
    required this.userId,
    required this.seriesId,
    required this.answeredQuestions,
    required this.correctNo,
    required this.wrongNo,
    required this.userName,
  });

  // Convert Firestore document to UserStats
  factory UserStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserStats(
      userId: data['userId'] as String,
      seriesId: data['seriesId'] as String,
      answeredQuestions:
          List<String>.from(data['answeredQuestions'] as List<dynamic>),
      correctNo: data['correctNo'] as int,
      wrongNo: data['wrongNo'] as int,
      userName: data['userName'] as String,
    );
  }
  UserStats.empty()
      : userId = '',
        seriesId = '',
        answeredQuestions = [],
        correctNo = 0,
        userName = '',
        wrongNo = 0;

  final String userId;
  final String seriesId;
  final List<String> answeredQuestions;
  final int correctNo;
  final int wrongNo;
  final String userName;

  // Convert UserStats to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'seriesId': seriesId,
      'answeredQuestions': answeredQuestions,
      'correctNo': correctNo,
      'wrongNo': wrongNo,
      'userName': userName,
    };
  }
}
