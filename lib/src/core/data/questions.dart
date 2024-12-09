// // import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';

// // ignore_for_file: public_member_api_docs, lines_longer_than_80_chars, duplicate_ignore


// import 'package:cinequizz/src/features/app/domain/entities/question_entity.dart';

// final questionData = <QuestionEntity>[
//     const QuestionEntity(
//       questionId: 'q1',
//       seriesId: 's1',
//       seriesName: 'Breaking Bad',
//       title:
//           'What subject did Walter White teach before becoming a drug manufacturer?',
//       opts: ['Physics', 'Chemistry', 'Biology', 'Mathematics'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q2',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title:
//           'What is the street name of the drug that Walter White and Jesse Pinkman produce?',
//       opts: ['Crack', 'Crystal', 'Blue Sky', 'Ice'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q3',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Who was the first main character to die in the series?',
//       opts: ['Jane Margolis', 'Tuco Salamanca', 'Krazy-8', 'Gale Boetticher'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q4',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title:
//           'What is the name of the fast-food chain owned by Gustavo "Gus" Fring?',
//       opts: [
//         'Pollos Locos',
//         'Los Pollos Hermanos',
//         'Chicken Brothers',
//         "Gus' Grub"
//       ],
//       answerNo: 1,
//     ),
//     // Additional questions
//     QuestionEntity(
//       questionId: 'q5',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'Who is Walter White\'s brother-in-law and DEA agent?',
//       opts: ['Hank Schrader', 'Saul Goodman', 'Gus Fring', 'Mike Ehrmantraut'],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q6',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is the name of Walter White\'s wife?',
//       opts: [
//         'Marie Schrader',
//         'Skyler White',
//         'Jane Margolis',
//         'Lydia Rodarte-Quayle'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q7',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is Jesse Pinkman\'s street name for his product?',
//       opts: ['Meth', 'Blue', 'Ice', 'Speed'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q8',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Which character is a private investigator and fixer?',
//       opts: ['Saul Goodman', 'Mike Ehrmantraut', 'Hank Schrader', 'Gus Fring'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q9',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Who plays the role of Walter White in Breaking Bad?',
//       opts: [
//         'Aaron Paul',
//         'Jonathan Banks',
//         'Bryan Cranston',
//         'Giancarlo Esposito'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q10',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is the name of the car wash Walter works at?',
//       opts: [
//         'Los Pollos Hermanos',
//         'A1A Car Wash',
//         'Better Call Saul',
//         'ABQ Car Wash'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q11',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'Who is the chemist that replaces Gale as Gus\'s cook?',
//       opts: [
//         'Lydia Rodarte-Quayle',
//         'Todd Alquist',
//         'Mike Ehrmantraut',
//         'Hank Schrader'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q12',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is the name of the location where Walter hides his money?',
//       opts: [
//         'A1A Car Wash',
//         'Under the house',
//         'In barrels in the desert',
//         'Saul\'s office'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q13',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Who is the lawyer that represents Walter White?',
//       opts: [
//         'Hank Schrader',
//         'Saul Goodman',
//         'Lydia Rodarte-Quayle',
//         'Jesse Pinkman'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q14',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title:
//           'What is the name of Jesse\'s girlfriend who dies from a drug overdose?',
//       opts: [
//         'Skyler White',
//         'Lydia Rodarte-Quayle',
//         'Jane Margolis',
//         'Marie Schrader'
//       ],
//       answerNo: 2,
//     ),
//   ];

//   // Uploading to Firestore

//   final bbQuestions = <QuestionEntity>[
//     QuestionEntity(
//       questionId: 'q1',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title:
//           'What is Walter White\'s profession before he turns to cooking meth?',
//       opts: ['Doctor', 'Teacher', 'Engineer', 'Lawyer'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q2',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is the name of Walter White\'s lawyer?',
//       opts: [
//         'Saul Goodman',
//         'Mike Ehrmantraut',
//         'Hank Schrader',
//         'Gustavo Fring'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q3',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is the name of Walter White\'s wife?',
//       opts: [
//         'Marie Schrader',
//         'Jane Margolis',
//         'Skyler White',
//         'Lydia Rodarte-Quayle'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q4',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What does Jesse Pinkman call methamphetamine?',
//       opts: ['Ice', 'Crystal', 'Blue Sky', 'Snow'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q5',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'Who is the DEA agent that is Walter White\'s brother-in-law?',
//       opts: [
//         'Saul Goodman',
//         'Mike Ehrmantraut',
//         'Hank Schrader',
//         'Gustavo Fring'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q6',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is the name of the fast food chain owned by Gustavo Fring?',
//       opts: [
//         'Pollos Hermanos',
//         'Big Kahuna Burger',
//         'Los Pollos Locos',
//         'Gus\' Grill'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q7',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What kind of cancer is Walter White diagnosed with?',
//       opts: ['Lung cancer', 'Brain cancer', 'Colon cancer', 'Breast cancer'],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q8',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What color is the methamphetamine that Walter and Jesse produce?',
//       opts: ['White', 'Pink', 'Blue', 'Green'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q9',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'Who is Walter White\'s former student and meth-making partner?',
//       opts: ['Saul Goodman', 'Hank Schrader', 'Gustavo Fring', 'Jesse Pinkman'],
//       answerNo: 3,
//     ),
//     QuestionEntity(
//       questionId: 'q10',
//       seriesId: 's1',
//       seriesName: findSeriesNameById(seriesData, 's1'),
//       title: 'What is Walter White\'s alias in the drug world?',
//       opts: ['Captain Cook', 'The Chemist', 'Heisenberg', 'The Teacher'],
//       answerNo: 2,
//     ),
//   ];

//   final saulQuestions = <QuestionEntity>[
//     QuestionEntity(
//       questionId: 'q1',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is Saul Goodman\'s real name?',
//       opts: [
//         'James McGill',
//         'Howard Hamlin',
//         'Chuck McGill',
//         'Mike Ehrmantraut'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q2',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is the name of Saul Goodman\'s brother?',
//       opts: ['Howard Hamlin', 'Chuck McGill', 'Nacho Varga', 'Gus Fring'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q3',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title:
//           'What is the name of the law firm Saul works for before starting his own practice?',
//       opts: [
//         'Davis & Main',
//         'Hamlin, Hamlin & McGill',
//         'Schweikart & Cokely',
//         'Wexler McGill'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q4',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Who does Saul partner with to run scams in the early seasons?',
//       opts: [
//         'Kim Wexler',
//         'Mike Ehrmantraut',
//         'Howard Hamlin',
//         'Marco Pasternak'
//       ],
//       answerNo: 3,
//     ),
//     QuestionEntity(
//       questionId: 'q5',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is the name of the character played by Michael Mando?',
//       opts: [
//         'Lalo Salamanca',
//         'Nacho Varga',
//         'Hector Salamanca',
//         'Tuco Salamanca'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q6',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What illness does Chuck McGill suffer from?',
//       opts: [
//         'Electromagnetic hypersensitivity',
//         'Paranoia',
//         'Schizophrenia',
//         'Bipolar disorder'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q7',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Who is the proprietor of Los Pollos Hermanos?',
//       opts: ['Hector Salamanca', 'Mike Ehrmantraut', 'Gus Fring', 'Kim Wexler'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q8',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is the relationship between Jimmy and Kim Wexler?',
//       opts: ['Friends', 'Colleagues', 'Romantic partners', 'Siblings'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q9',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'Where does Saul Goodman set up his office?',
//       opts: [
//         'In a strip mall',
//         'In a high-rise building',
//         'In a basement',
//         'In a house'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q10',
//       seriesId: 's2',
//       seriesName: findSeriesNameById(seriesData, 's2'),
//       title: 'What is the profession of Kim Wexler?',
//       opts: ['Doctor', 'Engineer', 'Lawyer', 'Teacher'],
//       answerNo: 2,
//     ),
//   ];
//   final sopranosQuestions = <QuestionEntity>[
//     QuestionEntity(
//       questionId: 'q1',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'Who is the head of the Soprano family?',
//       opts: [
//         'Paulie Gualtieri',
//         'Christopher Moltisanti',
//         'Silvio Dante',
//         'Tony Soprano'
//       ],
//       answerNo: 3,
//     ),
//     QuestionEntity(
//       questionId: 'q2',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'What is Tony Soprano\'s profession?',
//       opts: ['Doctor', 'Lawyer', 'Mob boss', 'Teacher'],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q3',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'What is the name of Tony\'s wife?',
//       opts: [
//         'Adriana La Cerva',
//         'Janice Soprano',
//         'Carmela Soprano',
//         'Meadow Soprano'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q4',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'What is the name of Tony Soprano\'s therapist?',
//       opts: ['Dr. Melfi', 'Dr. Cusamano', 'Dr. Kennedy', 'Dr. Wu'],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q5',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'Who is the main character\'s best friend and consignee?',
//       opts: [
//         'Silvio Dante',
//         'Paulie Gualtieri',
//         'Ralph Cifaretto',
//         'Artie Bucco'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q6',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title:
//           'What is the name of the restaurant owned by Tony\'s friend, Artie Bucco?',
//       opts: ['Vesuvio', 'Nuovo Vesuvio', 'Saturnalia', 'Nebula'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q7',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'Which character is known for his famous “Pine Barrens” episode?',
//       opts: [
//         'Paulie Gualtieri',
//         'Silvio Dante',
//         'Christopher Moltisanti',
//         'Bobby Baccalieri'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q8',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'Who is Tony\'s nephew and aspiring filmmaker?',
//       opts: [
//         'A.J. Soprano',
//         'Christopher Moltisanti',
//         'Bobby Baccalieri',
//         'Furio Giunta'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q9',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'What FBI agent is obsessed with bringing down Tony Soprano?',
//       opts: ['Agent Lipari', 'Agent Harris', 'Agent Cubitoso', 'Agent Grosso'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q10',
//       seriesId: 's3',
//       seriesName: findSeriesNameById(seriesData, 's3'),
//       title: 'What does Tony Soprano call his yacht?',
//       opts: ['The Stugots', 'The Suvorov', 'The Bellevue', 'The Santori'],
//       answerNo: 0,
//     ),
//   ];
//   final wireQuestions = <QuestionEntity>[
//     QuestionEntity(
//       questionId: 'q1',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What is the main setting of The Wire?',
//       opts: ['New York City', 'Baltimore', 'Chicago', 'Philadelphia'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q2',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'Who is the main character in Season 1 of The Wire?',
//       opts: [
//         'Bunk Moreland',
//         'Lester Freamon',
//         'Jimmy McNulty',
//         'Cedric Daniels'
//       ],
//       answerNo: 2,
//     ),
//     QuestionEntity(
//       questionId: 'q3',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What is the nickname of Omar Little?',
//       opts: ['The King', 'The Gunslinger', 'The Street', 'The Boy'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q4',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'Who is the drug kingpin in Season 1?',
//       opts: ['Stringer Bell', 'Avon Barksdale', 'Prop Joe', 'Marlo Stanfield'],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q5',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What is the name of the newspaper in Season 5?',
//       opts: ['The Sun', 'The Star', 'The Times', 'The Chronicle'],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q6',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'Who is the head of the Major Crimes Unit?',
//       opts: [
//         'Cedric Daniels',
//         'Jimmy McNulty',
//         'Bunk Moreland',
//         'Lester Freamon'
//       ],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q7',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What is the name of the dock worker\'s union president?',
//       opts: ['Frank Sobotka', 'Nick Sobotka', 'Ziggy Sobotka', 'Spiros Vondas'],
//       answerNo: 0,
//     ),
//     QuestionEntity(
//       questionId: 'q8',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What role does Dominic West play?',
//       opts: [
//         'Bunk Moreland',
//         'Jimmy McNulty',
//         'Cedric Daniels',
//         'Lester Freamon'
//       ],
//       answerNo: 1,
//     ),
//     QuestionEntity(
//       questionId: 'q9',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title: 'What unit does Kima Greggs work in?',
//       opts: ['Homicide', 'Vice', 'Narcotics', 'Major Crimes'],
//       answerNo: 3,
//     ),
//     QuestionEntity(
//       questionId: 'q10',
//       seriesId: 's4',
//       seriesName: findSeriesNameById(seriesData, 's4'),
//       title:
//           'What is the name of the character who is a former stick-up man and becomes a police informant?',
//       opts: ['Omar Little', 'Bubbles', 'Avon Barksdale', 'Stringer Bell'],
//       answerNo: 1,
//     ),
//   ];

//   for (var question in wireQuestions) async {
//     await db.collection('s4').doc(question.questionId).set(question.toJson());
//   }

//   for (final series in seriesData) {
//     await db.collection('series').doc(series.seriesId).set(series.toJson());
//   }











