import 'package:cinequizz/src/core/data/questions/01_breaking_bad/better_call_saul.quests.dart';
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

void saveAllQuestions() {
  for (var element in allwireQuests) {
    saveQuestions(element, element[0].seriesId);
  }
}
