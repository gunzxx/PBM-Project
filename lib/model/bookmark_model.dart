class BookmarkModel {
  final int id;
  final String name, description, location, latitude, longitude, thumb;
  final List previewUrl;

  BookmarkModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.thumb,
    required this.previewUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'thumb': thumb,
        'previewUrl': previewUrl,
      };
}
