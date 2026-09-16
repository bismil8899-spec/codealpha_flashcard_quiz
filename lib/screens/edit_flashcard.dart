import 'package:flutter/material.dart';
import '../data/flashcards.dart';
import '../services/firestore_service.dart';

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

  final FirestoreService firestoreService = FirestoreService();

  bool isUpdating = false;

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

  Future<void> updateFlashcard() async {
    if (questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      return;
    }

    if (widget.flashcard.id == null) {
      return;
    }

    setState(() {
      isUpdating = true;
    });

    try {
      await firestoreService.updateFlashcard(
        widget.flashcard.id!,
        questionController.text.trim(),
        answerController.text.trim(),
      );

      widget.flashcard.question =
          questionController.text.trim();

      widget.flashcard.answer =
          answerController.text.trim();

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isUpdating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating flashcard: $e"),
          ),
        );
      }
    }
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
                onPressed:
                    isUpdating ? null : updateFlashcard,
                child: isUpdating
                    ? const CircularProgressIndicator()
                    : const Text("Update Flashcard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}