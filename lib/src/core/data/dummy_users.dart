import 'dart:math';

import 'package:cinequizz/src/features/app/domain/entities/user_stats.dart';

final realNames = [
  'Alice Johnson',
  'Bob Smith',
  'Charlie Brown',
  'Diana Ross',
  'Eli Manning',
  'Fiona Apple',
  'George Harrison',
  'Hannah Montana',
  'Ian McKellen',
  'Jane Austen',
  'Kevin Bacon',
  'Lucy Liu',
  'Michael Jordan',
  'Nina Simone',
  'Oscar Wilde',
  'Penelope Cruz',
  'Quincy Jones',
  'Rachel McAdams',
  'Steve Jobs',
  'Tina Turner'
];

final random = Random(DateTime.now().millisecondsSinceEpoch);

final dummyUsers = List<UserStats>.generate(
  20,
  (index) {
    final correctNo =
        (index + 1) * 10 + random.nextInt(20); // Randomly add 0 to 19
    final wrongNo = index + random.nextInt(5); // Randomly add 0 to 4

    return UserStats(
        userId: 'dummyUser${index + 1}',
        userName: realNames[index],
        correctNo: correctNo,
        wrongNo: wrongNo,
        avatarSeed: realNames[index],
        answeredQuestions: [],
        totalNoAnswers: 10 // Add default empty list for answeredQuestions
        );
  },
);
