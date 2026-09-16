import 'package:flutter/material.dart';
import '../data/flashcards.dart';
import '../services/firestore_service.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final TextEditingController questionController =
      TextEditingController();

  final TextEditingController answerController =
      TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  bool isSaving = false;

  Future<void> saveFlashcard() async {
    if (questionController.text.trim().isEmpty ||
        answerController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await firestoreService.addFlashcard(
        questionController.text.trim(),
        answerController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving flashcard: $e"),
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
        title: const Text("Add Flashcard"),
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
                onPressed: isSaving ? null : saveFlashcard,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text("Save Flashcard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}