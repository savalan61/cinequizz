import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionEntity {
  const QuestionEntity({
    required this.questionId,
    required this.seriesId,
    required this.seriesName,
    required this.title,
    required this.opts,
    required this.answerNo,
  });

  factory QuestionEntity.empty() => const QuestionEntity(
        questionId: '',
        seriesId: '',
        seriesName: '',
        title: '',
        opts: [],
        answerNo: 0,
      );

  factory QuestionEntity.fromJson(Map<String, dynamic> json) {
    return QuestionEntity(
      questionId: json['questionId'] as String,
      seriesId: json['seriesId'] as String,
      seriesName: json['seriesName'] as String, // Include seriesName here
      title: json['title'] as String,
      opts: List<String>.from(json['opts'] as List<dynamic>),
      answerNo: json['answerNo'] as int,
    );
  }

  factory QuestionEntity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return QuestionEntity.fromJson(data);
  }

  final String questionId;
  final String seriesId;
  final String seriesName;
  final String title;
  final List<String> opts;
  final int answerNo;

  QuestionEntity copyWith({
    String? questionId,
    String? seriesId,
    String? seriesName,
    String? title,
    List<String>? opts,
    int? answerNo,
  }) {
    return QuestionEntity(
      questionId: questionId ?? this.questionId,
      seriesId: seriesId ?? this.seriesId,
      seriesName: seriesName ?? this.seriesName,
      title: title ?? this.title,
      opts: opts ?? this.opts,
      answerNo: answerNo ?? this.answerNo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'seriesId': seriesId,
      'seriesName': seriesName, // Ensure seriesName is included here
      'title': title,
      'opts': opts,
      'answerNo': answerNo,
    };
  }
}
