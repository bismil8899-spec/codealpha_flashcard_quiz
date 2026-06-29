class Flashcard {
  String question;
  String answer;

  Flashcard({
    required this.question,
    required this.answer,
  });
}

// LIST
List<Flashcard> flashcards = [
  Flashcard(
    question: "What is Software Engineering?",
    answer: "The systematic process of designing, developing, testing, and maintaining software.",
  ),

  Flashcard(
    question: "What is an Algorithm?",
    answer: "A step-by-step procedure used to solve a problem.",
  ),

  Flashcard(
    question: "What is a Flowchart?",
    answer: "A graphical representation of an algorithm or process.",
  ),

  Flashcard(
    question: "What is SDLC?",
    answer: "Software Development Life Cycle is the process of planning, developing, testing, deploying, and maintaining software.",
  ),

  Flashcard(
    question: "What is Object-Oriented Programming (OOP)?",
    answer: "A programming paradigm based on classes and objects.",
  ),

  Flashcard(
    question: "What is Encapsulation?",
    answer: "Wrapping data and methods into a single unit called a class.",
  ),

  Flashcard(
    question: "What is Inheritance?",
    answer: "A feature that allows one class to acquire the properties and methods of another class.",
  ),

  Flashcard(
    question: "What is Flutter?",
    answer: "Google's open-source UI toolkit for building cross-platform applications.",
  ),

  Flashcard(
    question: "What is Dart?",
    answer: "The programming language used to develop Flutter applications.",
  ),

  Flashcard(
    question: "What is a Database?",
    answer: "An organized collection of data that can be stored, managed, and retrieved efficiently.",
  ),
];

// ADD
void addFlashcard(String question, String answer) {
  flashcards.add(
    Flashcard(
      question: question,
      answer: answer,
    ),
  );
}

// DELETE
void deleteFlashcard(int index) {
  flashcards.removeAt(index);
}

// UPDATE
void updateFlashcard(int index, String question, String answer) {
  flashcards[index].question = question;
  flashcards[index].answer = answer;
}