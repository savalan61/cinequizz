// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_total_stats.dart';

class AppDataSource {
  AppDataSource({required FirebaseFirestore db}) : _db = db;

  final FirebaseFirestore _db;

  Future<List<QuestionEntity>> fetchAllQuestions() async {
    try {
      final QuerySnapshot querySnapshot =
          await _db.collection('questions').get();
      return querySnapshot.docs.map(QuestionEntity.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch Questions: $e');
    }
  }

  Stream<List<UserStats>> fetchUserStats({
    required String userId,
  }) {
    return _db
        .collection('userstats')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map(UserStats.fromFirestore).toList();
    });
  }

  Future<List<SeriesEntity>> fetchAllSeries() async {
    try {
      final QuerySnapshot querySnapshot = await _db.collection('series').get();
      return querySnapshot.docs.map(SeriesEntity.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch Series: $e');
    }
  }

  Future<List<QuestionEntity>> fetchSeriesQuestions(String seriesId) async {
    try {
      final QuerySnapshot querySnapshot = await _db.collection(seriesId).get();
      return querySnapshot.docs.map(QuestionEntity.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch Questions of $seriesId: $e');
    }
  }

  Future<void> saveAnsweredQuestion({
    required String userId,
    required String seriesId,
    required String questionId,
    required bool? isCorrect,
    required String userName,
  }) async {
    try {
      // Check if the question exists before saving the answer
      final questionDoc =
          await _db.collection('questions').doc(questionId).get();

      if (!questionDoc.exists) {
        throw Exception('Question does not exist.');
      }

      // Proceed to save answer if the question exists
      final answeredQuestionsData = {
        'answeredQuestions': FieldValue.arrayUnion([questionId]),
      };

      final userStatsDoc =
          await _db.collection('userstats').doc('${userId}_$seriesId').get();

      final userStatsData = userStatsDoc.exists
          ? userStatsDoc.data()!
          : {
              'userId': userId,
              'seriesId': seriesId,
              'answeredQuestions': <String>[],
              'correctNo': 0,
              'wrongNo': 0,
              'userName': userName,
            };

      userStatsData['answeredQuestions'].add(questionId);

      if (isCorrect != null) {
        if (isCorrect) {
          userStatsData['correctNo'] += 1;
        } else {
          userStatsData['wrongNo'] += 1;
        }
      }

      // Save updated answered questions to answeredquestions collection
      await _db
          .collection('answeredquestions')
          .doc('${userId}_$seriesId')
          .set(answeredQuestionsData, SetOptions(merge: true));

      // Save updated user stats to userstats collection
      await _db
          .collection('userstats')
          .doc('${userId}_$seriesId')
          .set(userStatsData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save answer: $e');
    }
  }

  Stream<List<UserTotalStats>> fetchAllUsersStats() {
    return _db.collection('userstats').snapshots().map((querySnapshot) {
      final userStats =
          querySnapshot.docs.map(UserStats.fromFirestore).toList();
      final result = <UserTotalStats>[];

      final totals = <String, Map<String, dynamic>>{};

      for (final stats in userStats) {
        if (!totals.containsKey(stats.userId)) {
          totals[stats.userId] = {
            'userId': stats.userId,
            'userName': stats.userName,
            'correctNo': 0,
            'wrongNo': 0,
          };
        }
        totals[stats.userId]!['correctNo'] += stats.correctNo;
        totals[stats.userId]!['wrongNo'] += stats.wrongNo;
      }

      for (final entry in totals.entries) {
        result.add(UserTotalStats.fromMap(entry.value));
      }

      return result;
    });
  }

  Future<Set<String>> fetchAnsweredQuestions(
    String userId,
    String seriesId,
  ) async {
    try {
      final DocumentSnapshot doc = await _db
          .collection('answeredquestions')
          .doc('${userId}_$seriesId')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()! as Map<String, dynamic>;
        final answeredQuestions = data['answeredQuestions'] as List<dynamic>;
        return answeredQuestions.map((e) => e.toString()).toSet();
      } else {
        return <String>{}; // Empty set if no answered questions found
      }
    } catch (e) {
      throw Exception('Failed to fetch Answered Questions: $e');
    }
  }

  Future<List<QuestionEntity>> fetchUnansweredQuestions({
    required String userId,
    required String seriesId,
  }) async {
    try {
      final allQuestions = await fetchSeriesQuestions(seriesId);
      final answeredQuestions = await fetchAnsweredQuestions(userId, seriesId);

      final unansweredQuestions = allQuestions
          .where((question) => !answeredQuestions.contains(question.questionId))
          .toList();
      return unansweredQuestions;
    } catch (e) {
      throw Exception('Failed to fetch Unanswered Questions: $e');
    }
  }
}
