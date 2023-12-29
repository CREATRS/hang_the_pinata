class User {
  const User({
    this.sourceLanguage,
    this.targetLanguage,
    this.bestScore = 0,
    this.purchasesUserId,
    this.isPremium = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sourceLanguage: json['source_language'],
      targetLanguage: json['target_language'],
      bestScore: json['best_score'],
      purchasesUserId: json['purchases_user_id'],
      isPremium: json['is_premium'],
    );
  }

  final String? sourceLanguage;
  final String? targetLanguage;
  final int bestScore;
  final String? purchasesUserId;
  final bool isPremium;

  Map<String, dynamic> toJson() {
    return {
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'best_score': bestScore,
      'purchases_user_id': purchasesUserId,
      'is_premium': isPremium,
    };
  }

  User copyWith({
    String? sourceLanguage,
    String? targetLanguage,
    int? bestScore,
    String? purchasesUserId,
    bool? isPremium,
  }) {
    return User(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      bestScore: bestScore ?? this.bestScore,
      purchasesUserId: purchasesUserId ?? this.purchasesUserId,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  bool get hasLanguages => sourceLanguage != null && targetLanguage != null;
}
