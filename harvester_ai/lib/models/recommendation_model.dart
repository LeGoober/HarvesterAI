class RecommendationModel {
  final String cropName;
  final int matchPercentage;
  final int yieldIncrease; // percentage
  final int profitIncrease; // in Rand
  final String reason;

  RecommendationModel({
    required this.cropName,
    required this.matchPercentage,
    required this.yieldIncrease,
    required this.profitIncrease,
    required this.reason,
  });
}
