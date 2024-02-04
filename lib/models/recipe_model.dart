class RecipeModel {
  String label;
  String? image; // Make it nullable if you wish to pass null
  String source;
  String url;

  RecipeModel({
    required this.url,
    required this.source,
    required this.label,
    this.image, // Remove 'required' if you're making it nullable
  });

  factory RecipeModel.fromMap(Map<String, dynamic> parsedJson) {
    return RecipeModel(
      url: parsedJson["url"],
      label: parsedJson["label"],
      image: parsedJson["image"],
      source: parsedJson["source"],
    );
  }
}