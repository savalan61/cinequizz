// ignore_for_file: file_names

import 'package:cinequizz/src/core/data/questions/series/arcane.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

final questions = quests; //! just change series source then run run()
void run() => saveSeriesAndQuestions(
      questions: questions,
      imgUrl:
          '''A drama about one of New York's most prestigious ad agencies at the beginning of the 1960s, focusing on one of the firm's most mysterious but extremely talented ad executives, Donald Draper.

''',

      ///
      description:
          '''Sheriff Deputy Rick Grimes wakes up from a coma to learn the world is in ruins and must lead a group of survivors to stay alive.
''',

      ///
      info: '2010–2022',
      rating: '8.1',
    );

void saveSeriesAndQuestions({
  required List<QuestionEntity> questions,
  required imgUrl,
  required description,
  required info,
  required rating,
}) async {
  var seriesId = questions[0].seriesId;
  var name = questions[0].seriesName;
  var totalquestions = questions.length;

  for (var question in questions) {
    await _db
        .collection('series_questions')
        .doc(seriesId)
        .collection('questions')
        .doc(question.questionId)
        .set(question.toJson());
  }
  await _db.collection('series').doc(seriesId).set(SeriesEntity(
          seriesId: seriesId,
          name: name,
          imgUrl: imgUrl,
          description: description,
          info: info,
          rating: rating,
          totalQuestionNo: totalquestions)
      .toJson());
}

// List<QuestionEntity> seriesAllQuestions = lostTotalQuestions;
// var seiesId = seriesAllQuestions[0].seriesId;
// var name = seriesAllQuestions[0].seriesName;
// var totalquestions = seriesAllQuestions.length;

// Future<void> saveQuestions(
//     List<QuestionEntity> questions, String seriesId) async {
//   for (var question in questions) {
//     await _db
//         .collection('series_questions')
//         .doc(seriesId)
//         .collection('questions')
//         .doc(question.questionId)
//         .set(question.toJson());
//   }
// }

//*********************************************************************** */

/// Fot List of Series
// const imgUrl = '';
// const description = '';
// const info = '';
// const rating = '';
// void saveSeries() {
//   _db.collection('series').doc(seiesId).set(SeriesEntity(
//           seriesId: seiesId,
//           name: name,
//           imgUrl: imgUrl,
//           description: description,
//           info: info,
//           rating: rating,
//           totalQuestionNo: totalquestions)
//       .toJson());
// }
