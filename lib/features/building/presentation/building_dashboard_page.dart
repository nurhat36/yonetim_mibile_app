import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/secure_storage.dart';
import '../provider/building_provider.dart';

class BuildingDashboardPage extends StatefulWidget {
  final int buildingId;

  const BuildingDashboardPage({super.key, required this.buildingId});

  @override
  State<BuildingDashboardPage> createState() => _BuildingDashboardPageState();
}

class _BuildingDashboardPageState extends State<BuildingDashboardPage> {
  late Future<BuildingDashboard> dashboardFuture;

  @override
  void initState() {
    super.initState();
    dashboardFuture = fetchDashboard(widget.buildingId);
  }

  Future<BuildingDashboard> fetchDashboard(int buildingId) async {
    final token = await SecureStorage.getToken();
    print("token : $token");
   // Login sonrası kaydedilen token

    if (token == null) throw Exception('Kullanıcı login değil');

    final url = 'http://10.0.2.2:5268/api/Buildings/$buildingId/dashboard';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return BuildingDashboard.fromJson(jsonData);
    } else {
      throw Exception('Dashboard verisi alınamadı: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Building Dashboard"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<BuildingDashboard>(
        future: dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Veri bulunamadı'));
          }

          final dashboard = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dashboard.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),

                const SizedBox(height: 16),

                // Finansal özet kartları
                _buildFinanceCard(
                    "Toplam Gelir", dashboard.totalIncome, Colors.green),
                _buildFinanceCard(
                    "Toplam Gider", dashboard.totalExpense, Colors.red),
                _buildFinanceCard(
                    "Bakiye", dashboard.balance, Colors.blue),
                _buildFinanceCard(
                    "Aidat Borcu", dashboard.userDebt, Colors.orange),

                const SizedBox(height: 24),

                Text("Son 6 Ay Gelir / Gider",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),

                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _getMaxY(dashboard),
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < dashboard.lastSixMonths.length) {
                                return Text(dashboard.lastSixMonths[index], style: const TextStyle(fontSize: 10));
                              } else {
                                return const Text('');
                              }
                            },
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2000,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                            },
                            reservedSize: 28,
                          ),
                        ),

                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(
                        dashboard.lastSixMonths.length,
                            (index) => BarChartGroupData(
                          x: index,
                          barsSpace: 4,
                          barRods: [
                            BarChartRodData(
                              toY: dashboard.incomeByMonth[index],
                              color: Colors.green,
                              width: 12,
                            ),
                            BarChartRodData(
                              toY: dashboard.expenseByMonth[index],
                              color: Colors.red,
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                _buildInfoTile("Ödenmiş Aidatlar", dashboard.paidDues.toString()),
                _buildInfoTile(
                    "Ödenmemiş Aidatlar", dashboard.unpaidDues.toString()),
                _buildInfoTile(
                    "Ödenmiş Yüzdesi", "${dashboard.paidDuesPercentage}%"),
                _buildInfoTile(
                    "Bekleyen Şikayetler", dashboard.pendingComplaints.toString()),
                _buildInfoTile(
                    "Son 30 gün Gelir Sayısı", dashboard.recentIncomeCount.toString()),
                _buildInfoTile(
                    "Son 30 gün Gider Sayısı", dashboard.recentExpenseCount.toString()),
                _buildInfoTile("Son 30 gün Duyuru Sayısı",
                    dashboard.recentAnnouncements.toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinanceCard(String label, double value, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.attach_money, color: color),
        title: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Text("$value ₺",
            style: TextStyle(fontSize: 16, color: color)),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  double _getMaxY(BuildingDashboard dashboard) {
    final maxIncome =
    dashboard.incomeByMonth.isNotEmpty ? dashboard.incomeByMonth.reduce((a, b) => a > b ? a : b) : 0;
    final maxExpense =
    dashboard.expenseByMonth.isNotEmpty ? dashboard.expenseByMonth.reduce((a, b) => a > b ? a : b) : 0;
    return (maxIncome > maxExpense ? maxIncome : maxExpense) * 1.2;
  }
}

// MODEL
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
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      address: json['address'] ?? '',
      unitCount: json['unitCount'] ?? 0,
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      userDebt: (json['userDebt'] ?? 0).toDouble(),
      lastPaymentDate: json['lastPaymentDate'] != null
          ? DateTime.parse(json['lastPaymentDate'])
          : null,
      lastSixMonths: List<String>.from(json['lastSixMonths'] ?? []),
      incomeByMonth: _toDoubleList(json['incomeByMonth']),
      expenseByMonth: _toDoubleList(json['expenseByMonth']),
      paidDues: json['paidDues'] ?? 0,
      unpaidDues: json['unpaidDues'] ?? 0,
      paidDuesPercentage: json['paidDuesPercentage'] ?? 0,
      pendingComplaints: json['pendingComplaints'] ?? 0,
      recentIncomeCount: json['recentIncomeCount'] ?? 0,
      recentExpenseCount: json['recentExpenseCount'] ?? 0,
      recentAnnouncements: json['recentAnnouncements'] ?? 0,
    );
  }
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
