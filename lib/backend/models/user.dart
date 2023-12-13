class User {
  final String? sourceLanguage;
  final String? targetLanguage;
  final int bestScore;

  const User({
    this.sourceLanguage,
    this.targetLanguage,
    this.bestScore = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sourceLanguage: json['source_language'],
      targetLanguage: json['target_language'],
      bestScore: json['best_score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'best_score': bestScore,
    };
  }

  User copyWith({
    String? sourceLanguage,
    String? targetLanguage,
    int? bestScore,
  }) {
    return User(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      bestScore: bestScore ?? this.bestScore,
    );
  }

  bool get hasLanguages => sourceLanguage != null && targetLanguage != null;
}
