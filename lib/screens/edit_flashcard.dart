
import 'package:flutter/material.dart';
import '../data/flashcards.dart';

class EditFlashcardScreen extends StatefulWidget {
  final Flashcard flashcard;

  const EditFlashcardScreen({
    super.key,
    required this.flashcard,
  });

  @override
  State<EditFlashcardScreen> createState() =>
      _EditFlashcardScreenState();
}

class _EditFlashcardScreenState extends State<EditFlashcardScreen> {
  late TextEditingController questionController;
  late TextEditingController answerController;

  @override
  void initState() {
    super.initState();

    questionController = TextEditingController(
      text: widget.flashcard.question,
    );

    answerController = TextEditingController(
      text: widget.flashcard.answer,
    );
  }

  void updateFlashcard() {
    if (questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      widget.flashcard.question = questionController.text.trim();
      widget.flashcard.answer = answerController.text.trim();
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Flashcard"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateFlashcard,
                child: const Text("Update Flashcard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
