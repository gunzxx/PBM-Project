class HomeTouristModel {
  final int id;
  final String name, description, location, latitude, longitude, thumb;
  final List previewUrl;

  HomeTouristModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.thumb,
    required this.previewUrl,
  });
}
