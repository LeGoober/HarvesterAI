class WeatherAlertModel {
  final String alertType; // e.g., "Heat Wave", "Frost Warning", "Drought Alert"
  final String description;
  final String severity; // "Low", "Medium", "High", "Critical"
  final int daysUntil; // days until alert affects farm

  WeatherAlertModel({
    required this.alertType,
    required this.description,
    required this.severity,
    required this.daysUntil,
  });
}
