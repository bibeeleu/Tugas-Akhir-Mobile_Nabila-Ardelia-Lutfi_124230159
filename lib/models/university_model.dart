class University {
  final String name;
  final String country;
  final List<String> webPages;

  University({
    required this.name,
    required this.country,
    required this.webPages,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      country: json['country'],
      webPages: List<String>.from(json['web_pages']),
    );
  }
}
