// ignore_for_file: avoid_dynamic_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';
import 'package:flutter/foundation.dart';

class AppDataSource {
  AppDataSource({required FirebaseFirestore db}) : _db = db;

  final FirebaseFirestore _db;

// Function to fetch all questions for a given series
  Future<List<QuestionEntity>> fetchAllQuestions(String seriesId) async {
    final seriesDoc = await _db
        .collection('series_questions')
        .doc(seriesId)
        .collection('questions')
        .get();
    if (seriesDoc.docs.isNotEmpty) {
      return seriesDoc.docs
          .map((doc) => QuestionEntity.fromFirestore(doc))
          .toList();
    } else {
      return [];
    }
  }

// Function to fetch user's answered questions for a given series
  Future<List<String>> fetchAnsweredQuestions(
      String userId, String seriesId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      final answers = data['answers'] as Map<String, dynamic>;
      final answeredQuestions = answers[seriesId] as List<dynamic>? ?? [];

      if (answeredQuestions.isNotEmpty) {
        final answeredQuestionIds =
            answeredQuestions.map((e) => e['questionId'] as String).toList();
        return answeredQuestionIds;
        // final querySnapshot = await _db
        //     .collection(seriesId)
        //     .where(FieldPath.documentId, whereIn: answeredQuestionIds)
        //     .get();
        // return querySnapshot.docs
        //     .map((doc) => QuestionEntity.fromFirestore(doc))
        //     .toList();
      }
    }
    return [];
  }

  // Function to determine unanswered questions
  Future<List<QuestionEntity>> fetchUnansweredQuestions(
      {required String userId, required String seriesId}) async {
    final allQuestions = await fetchAllQuestions(seriesId);
    final answeredQuestions = await fetchAnsweredQuestions(userId, seriesId);

    // final answeredQuestionIds =
    //     answeredQuestions.map((q) => q.questionId).toSet();
    final unansweredQuestions = allQuestions
        .where((q) => !answeredQuestions.contains(q.questionId))
        .toList();

    return unansweredQuestions;
  }

  Stream<UserStats> fetchUserStats({
    required String userId,
  }) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      try {
        if (snapshot.exists) {
          return UserStats.fromFirestore(snapshot);
        } else {
          // Return an empty UserStats object if the document does not exist
          return const UserStats.empty();
        }
      } catch (e) {
        // Optionally, return an empty UserStats object or handle the error as needed
        return const UserStats.empty();
      }
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

  Future<void> saveAnsweredQuestion({
    required String userId,
    required String seriesId,
    required String questionId,
    required bool? isCorrect,
    required String userName,
    required String avatarSeed,
  }) async {
    try {
      final userDoc = _db.collection('users').doc(userId);
      final userSnapshot = await userDoc.get();

      final answerData = {
        'questionId': questionId,
        'status': isCorrect == true
            ? 'correct'
            : (isCorrect == false ? 'wrong' : 'no_choice')
      };

      if (userSnapshot.exists) {
        final userData = userSnapshot.data()!;
        int correctNo = userData['correctNo'] ?? 0;
        int wrongNo = userData['wrongNo'] ?? 0;

        if (isCorrect == true) {
          correctNo += 1;
        } else if (isCorrect == false) {
          wrongNo += 1;
        }

        await userDoc.update({
          'correctNo': correctNo,
          'wrongNo': wrongNo,
          'answers.$seriesId': FieldValue.arrayUnion([answerData]),
        });
      } else {
        // If the user document does not exist, create it with the initial values
        await userDoc.set({
          'userId': userId,
          'userName': userName,
          'avatarSeed': avatarSeed,
          'correctNo': isCorrect == true ? 1 : 0,
          'wrongNo': isCorrect == false ? 1 : 0,
          'answers': {
            seriesId: [answerData],
          },
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
    }
  }

  Stream<List<UserStats>> fetchAllUsersStats() {
    return _db.collection('users').snapshots().map((snapshot) {
      try {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) {
            return UserStats.fromFirestore(doc);
          }).toList();
        } else {
          return []; // Return an empty list if no documents exist
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching all users stats: $e');
        }
        return []; // Optionally handle error by returning an empty list
      }
    });
  }
}
