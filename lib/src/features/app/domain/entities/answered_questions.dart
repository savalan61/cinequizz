class AnsweredQuestions {
  final String seriesId;
  final List<Map<String, dynamic>> questions;
  final int correctCount;
  final int wrongCount;

  AnsweredQuestions({
    required this.seriesId,
    required this.questions,
    required this.correctCount,
    required this.wrongCount,
  });

  factory AnsweredQuestions.empty() {
    return AnsweredQuestions(
      seriesId: '',
      questions: [],
      correctCount: 0,
      wrongCount: 0,
    );
  }

  factory AnsweredQuestions.fromFirestore(
      List<dynamic>? data, String seriesId) {
    int correctCount = 0;
    int wrongCount = 0;
    final questions = data != null
        ? data.map((e) {
            final questionMap = Map<String, dynamic>.from(e as Map);
            if (questionMap['status'] == 'correct') {
              correctCount++;
            } else if (questionMap['status'] == 'wrong') {
              wrongCount++;
            }
            return questionMap;
          }).toList()
        : <Map<String, dynamic>>[];

    return AnsweredQuestions(
      seriesId: seriesId,
      questions: questions,
      correctCount: correctCount,
      wrongCount: wrongCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seriesId': seriesId,
      'questions': questions,
      'correctCount': correctCount,
      'wrongCount': wrongCount,
    };
  }
}
