import 'package:flutter/material.dart';
import '../data/flashcards.dart';
import 'add_flashcard.dart';
import 'edit_flashcard.dart';
import '/services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  bool showAnswer = false;
  bool isLoading = true;

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  // LOAD FROM FIRESTORE
  Future<void> loadFlashcards() async {
    try {
      final firestoreCards = await firestoreService.getFlashcards();

      if (firestoreCards.isEmpty) {
        // First time: upload original 10 cards
        for (final card in flashcards) {
          await firestoreService.addFlashcard(
            card.question,
            card.answer,
          );
        }

        // Load again with Firestore document IDs
        final updatedCards = await firestoreService.getFlashcards();

        setState(() {
          flashcards = updatedCards;
          isLoading = false;
        });
      } else {
        setState(() {
          flashcards = firestoreCards;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading flashcards: $e"),
          ),
        );
      }
    }
  }

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  // DELETE
  Future<void> deleteCard() async {
    if (flashcards.isEmpty) return;

    final card = flashcards[currentIndex];

    try {
      if (card.id != null) {
        await firestoreService.deleteFlashcard(card.id!);
      }

      setState(() {
        flashcards.removeAt(currentIndex);

        if (flashcards.isEmpty) {
          currentIndex = 0;
          showAnswer = false;
          return;
        }

        if (currentIndex >= flashcards.length) {
          currentIndex = flashcards.length - 1;
        }

        showAnswer = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error deleting flashcard: $e"),
          ),
        );
      }
    }
  }

  // EDIT
  Future<void> editCard() async {
    if (flashcards.isEmpty) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditFlashcardScreen(
          flashcard: flashcards[currentIndex],
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF5F7FA),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.indigo,
          ),
        ),
      );
    }

    if (flashcards.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0,
          centerTitle: true,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                "Flashcard Quiz",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddFlashcardScreen(),
              ),
            );

            await loadFlashcards();
          },
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 90,
                color: Colors.indigo,
              ),
              SizedBox(height: 20),
              Text(
                "No Flashcards Yet",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Tap the + button to add your first flashcard.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final card = flashcards[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              "Flashcard Quiz",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddFlashcardScreen(),
            ),
          );

          await loadFlashcards();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 45,
              color: Colors.indigo,
            ),

            const SizedBox(height: 10),

            Text(
              "Flashcard ${currentIndex + 1} of ${flashcards.length}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 12,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 45,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    showAnswer ? card.answer : card.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  showAnswer
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                label: Text(
                  showAnswer
                      ? "Hide Answer"
                      : "Show Answer",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    showAnswer = !showAnswer;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: previousCard,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Previous"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: nextCard,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: editCard,
                icon: const Icon(Icons.edit),
                label: const Text("Edit Flashcard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: deleteCard,
                icon: const Icon(Icons.delete),
                label: const Text("Delete Flashcard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}