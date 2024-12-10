// ignore_for_file: file_names

import 'package:cinequizz/src/core/data/questions/01_breaking_bad/better_call_saul.quests.dart';
import 'package:cinequizz/src/core/data/questions/01_breaking_bad/breaking_bad_quests.dart';
import 'package:cinequizz/src/core/data/questions/01_breaking_bad/sopranos_quests.dart';
import 'package:cinequizz/src/core/data/questions/01_breaking_bad/the_wire_quests.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<void> saveQuestions(
    List<QuestionEntity> questions, String seriesId) async {
  for (var question in questions) {
    await _db
        .collection('series_questions')
        .doc(seriesId)
        .collection('questions')
        .doc(question.questionId)
        .set(question.toJson());
  }
}

final allSeries = [
  allBetterCallSaulsQuestions,
  allBreakingBadSeasons,
  allSopranosQuestions,
  allWireQuests
];

void saveAllQuestions() {
  for (var e in allSeries) {
    for (var element in e) {
      saveQuestions(element, element[0].seriesId);
    }
  }
}
