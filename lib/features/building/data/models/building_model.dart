

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


class Expense {
  final String name;
  final double amount;

  Expense({required this.name, required this.amount});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class Income {
  final String name;
  final double amount;

  Income({required this.name, required this.amount});

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }
}

class UserDebt {
  final String description;
  final double amount;
  final bool isPaid;

  UserDebt({required this.description, required this.amount, required this.isPaid});

  factory UserDebt.fromJson(Map<String, dynamic> json) {
    return UserDebt(
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isPaid: json['isPaid'] ?? false,
    );
  }
}

class BuildingModel {
  final int id;
  final String name;
  final String address;
  final String? imageUrl;
  final String? block;
  final int? floorCount;
  final int? unitCount;
  final List<Expense> expenses;
  final List<Income> incomes;
  final List<UserDebt> userDebts;

  BuildingModel({
    required this.id,
    required this.name,
    required this.address,
    this.imageUrl,
    this.block,
    this.floorCount,
    this.unitCount,
    this.expenses = const [],
    this.incomes = const [],
    this.userDebts = const [],
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'],
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['imageUrl'],
      block: json['block'],
      floorCount: json['floorCount'],
      unitCount: json['unitCount'],
      expenses: (json['expenses'] as List<dynamic>? ?? [])
          .map((e) => Expense.fromJson(e))
          .toList(),
      incomes: (json['incomes'] as List<dynamic>? ?? [])
          .map((e) => Income.fromJson(e))
          .toList(),
      userDebts: (json['userDebts'] as List<dynamic>? ?? [])
          .map((e) => UserDebt.fromJson(e))
          .toList(),
    );
  }
}
