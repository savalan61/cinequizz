import 'package:cinequizz/src/features/app/domain/entities/answered_questions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStats {
  const UserStats({
    required this.userId,
    required this.answeredQuestions,
    required this.correctNo,
    required this.wrongNo,
    required this.userName,
    required this.avatarSeed,
  });

  // Convert Firestore document to UserStats
  factory UserStats.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    final answersData = data['answers'] as Map<String, dynamic>? ?? {};
    final answeredQuestions = answersData.entries.map((entry) {
      return AnsweredQuestions.fromFirestore(
          entry.value as List<dynamic>?, entry.key);
    }).toList();

    return UserStats(
      userId: data['userId'] as String? ?? '',
      answeredQuestions: answeredQuestions,
      correctNo: data['correctNo'] as int? ?? 0,
      wrongNo: data['wrongNo'] as int? ?? 0,
      userName: data['userName'] as String? ?? '',
      avatarSeed: data['avatarSeed'] as String? ?? '',
    );
  }

  const UserStats.empty()
      : userId = '',
        answeredQuestions = const [],
        correctNo = 0,
        wrongNo = 0,
        userName = '',
        avatarSeed = '';

  final String userId;
  final List<AnsweredQuestions> answeredQuestions;
  final int correctNo;
  final int wrongNo;
  final String userName;
  final String avatarSeed;

  // Convert UserStats to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'answers': {
        for (var ans in answeredQuestions) ans.seriesId: ans.questions
      },
      'correctNo': correctNo,
      'wrongNo': wrongNo,
      'userName': userName,
      'avatarSeed': avatarSeed,
    };
  }
}
