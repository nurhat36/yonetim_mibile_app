

class BuildingResponse {
  final BuildingModel building;
  final String role;

  BuildingResponse({
    required this.building,
    required this.role,
  });

  factory BuildingResponse.fromJson(Map<String, dynamic> json) {
    return BuildingResponse(
      building: BuildingModel.fromJson(json['building']),
      role: json['role'] ?? '', // role null ise boş string
    );
  }
}


class BuildingModel {
  final int id;
  final String name;
  final String address;
  final String? type;
  final String? block;
  final int? floorCount;
  final int? unitCount;
  final String? description;
  final String? imageUrl;

  BuildingModel({
    required this.id,
    required this.name,
    required this.address,
    this.type,
    this.block,
    this.floorCount,
    this.unitCount,
    this.description,
    this.imageUrl,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      type: json['type'],
      block: json['block'],
      floorCount: json['floorCount'],
      unitCount: json['unitCount'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
