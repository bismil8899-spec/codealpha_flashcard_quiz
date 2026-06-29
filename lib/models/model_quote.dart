class Quote {
  String text;
  String author;
  bool isFavorite;

  Quote({
    required this.text,
    required this.author,
    this.isFavorite = false,
  });

  // Convert object → JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'isFavorite': isFavorite,
    };
  }

  // Convert JSON → object
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] ?? '',
      author: json['author'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}