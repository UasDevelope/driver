abstract class BaseModel {
  /// Convert the model to a Map
  Map<String, dynamic> toMap();

  /// Create a model from a Map
  factory BaseModel.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}