import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/flashcards.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> flashcardsCollection =
      FirebaseFirestore.instance.collection('flashcards');

  // LOAD FLASHCARDS
  Future<List<Flashcard>> getFlashcards() async {
    final snapshot = await flashcardsCollection.get();

    return snapshot.docs
        .map((doc) => Flashcard.fromFirestore(doc))
        .toList();
  }

  // ADD FLASHCARD
  Future<void> addFlashcard(
    String question,
    String answer,
  ) async {
    await flashcardsCollection.add({
      'question': question,
      'answer': answer,
    });
  }

  // UPDATE FLASHCARD
  Future<void> updateFlashcard(
    String id,
    String question,
    String answer,
  ) async {
    await flashcardsCollection.doc(id).update({
      'question': question,
      'answer': answer,
    });
  }

  // DELETE FLASHCARD
  Future<void> deleteFlashcard(String id) async {
    await flashcardsCollection.doc(id).delete();
  }
}