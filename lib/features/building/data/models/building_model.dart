class BuildingModel {
  final int id;
  final String name;
  final String address;

  BuildingModel({
    required this.id,
    required this.name,
    required this.address,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }
}
