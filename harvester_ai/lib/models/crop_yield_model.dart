class CropYieldModel {
  final String cropName;
  final double yieldPercentage; // 0-100
  final String season; // e.g., "2024 Spring", "Current Season"

  CropYieldModel({
    required this.cropName,
    required this.yieldPercentage,
    required this.season,
  });
}
