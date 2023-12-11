import 'word.dart';

class WordPack {
  final int id;
  final String name;
  final List<Word> words;
  // final double price;
  final double rating;
  final String image;

  const WordPack({
    required this.id,
    required this.name,
    required this.words,
    // required this.price,
    required this.rating,
    required this.image,
  });

  factory WordPack.fromJson(Map<String, dynamic> json) {
    return WordPack(
      id: json['id'],
      name: json['name'],
      words: List<Word>.from(
        json['words'].map(
          (word) => Word.fromJson(word),
        ),
      ),
      // price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'words': words,
        // 'price': price,
        'rating': rating,
        'image': image,
      };
}
