// ignore_for_file: file_names

import 'package:cinequizz/src/core/data/questions/series/arcane.dart';
import 'package:cinequizz/src/core/data/questions/series/attack_on_titan.dart';
import 'package:cinequizz/src/core/data/questions/series/chernobyl.dart';
import 'package:cinequizz/src/core/data/questions/series/dexter.dart';
import 'package:cinequizz/src/core/data/questions/series/peack_blinders.dart';
import 'package:cinequizz/src/core/data/questions/series/the_penguin.dart';
import 'package:cinequizz/src/core/data/questions/series/true_detectice.dart';
import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';
import 'package:cinequizz/src/features/app/domain/entities/series_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

final questions = arcane; //! just change series source then run run()
void run() => saveSeriesAndQuestions(
      questions: questions,
      imgUrl:
          '''https://firebasestorage.googleapis.com/v0/b/store-65e6b.appspot.com/o/movie%2Fseries_images%2Fdexter.png?alt=media&token=8a830b44-ffc3-4fc9-aebe-c713d198f06a''',

      ///
      description:
          '''Amid the stark discord of twin cities Piltover and Zaun, two 
          sisters fight on rival sides of a war between magic technologies 
          and clashing convictions.''',

      ///
      info: '2021–2024',
      rating: '9.1',
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
