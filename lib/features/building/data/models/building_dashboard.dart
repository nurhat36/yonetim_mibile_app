class BuildingDashboard {
  final int id;
  final String name;
  final String type;
  final String address;
  final int unitCount;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final double userDebt;
  final DateTime? lastPaymentDate;
  final List<String> lastSixMonths;
  final List<double> incomeByMonth;
  final List<double> expenseByMonth;
  final int paidDues;
  final int unpaidDues;
  final int paidDuesPercentage;
  final int pendingComplaints;
  final int recentIncomeCount;
  final int recentExpenseCount;
  final int recentAnnouncements;

  BuildingDashboard({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.unitCount,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.userDebt,
    required this.lastPaymentDate,
    required this.lastSixMonths,
    required this.incomeByMonth,
    required this.expenseByMonth,
    required this.paidDues,
    required this.unpaidDues,
    required this.paidDuesPercentage,
    required this.pendingComplaints,
    required this.recentIncomeCount,
    required this.recentExpenseCount,
    required this.recentAnnouncements,
  });

  factory BuildingDashboard.fromJson(Map<String, dynamic> json) {
    return BuildingDashboard(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      unitCount: (json['unitCount'] ?? 0) is int
          ? json['unitCount'] ?? 0
          : int.tryParse('${json['unitCount']}') ?? 0,
      totalIncome: _toDouble(json['totalIncome']),
      totalExpense: _toDouble(json['totalExpense']),
      balance: _toDouble(json['balance']),
      userDebt: _toDouble(json['userDebt']),
      lastPaymentDate: _toDate(json['lastPaymentDate']),
      lastSixMonths: _toStringList(json['lastSixMonths']),
      incomeByMonth: _toDoubleList(json['incomeByMonth']),
      expenseByMonth: _toDoubleList(json['expenseByMonth']),
      paidDues: _toInt(json['paidDues']),
      unpaidDues: _toInt(json['unpaidDues']),
      paidDuesPercentage: _toInt(json['paidDuesPercentage']),
      pendingComplaints: _toInt(json['pendingComplaints']),
      recentIncomeCount: _toInt(json['recentIncomeCount']),
      recentExpenseCount: _toInt(json['recentExpenseCount']),
      recentAnnouncements: _toInt(json['recentAnnouncements']),
    );
  }

  // ---- Helpers ----

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '.')) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) {
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static List<String> _toStringList(dynamic v) {
    if (v is List) {
      return v.map((e) => e?.toString() ?? '').toList();
    }
    return <String>[];
  }

  static List<double> _toDoubleList(dynamic v) {
    if (v is List) {
      return v.map<double>((e) {
        if (e == null) return 0.0;
        if (e is num) return e.toDouble();
        if (e is String) return double.tryParse(e.replaceAll(',', '.')) ?? 0.0;
        return 0.0;
      }).toList();
    }
    return <double>[];
  }
}
