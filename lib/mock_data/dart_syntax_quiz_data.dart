class Quiz {
  final String question;
  final String answer;

  Quiz({required this.question, required this.answer});
}

List<Quiz> dartQuizzes = [
  Quiz(question: "Dart's null safety symbol?", answer: "?"),
  Quiz(question: "Creates Dart object?", answer: "Constructor"),
  Quiz(question: "Starts Dart app?", answer: "main()"),
  Quiz(question: "Dart's list type?", answer: "List"),
  Quiz(question: "Async function return?", answer: "Future"),
  Quiz(question: "Dart private variable prefix?", answer: "_"),
  Quiz(question: "Immutable variable?", answer: "final"),
  Quiz(question: "Inherit a class?", answer: "extends"),
  Quiz(question: "Dart's map type?", answer: "Map"),
  Quiz(question: "Function inside class?", answer: "Method"),
];
