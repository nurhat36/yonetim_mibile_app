import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BuildingDashboardPage extends StatelessWidget {
  final String buildingName;
  final String manager;
  final int apartmentCount;
  final List<double> incomeByMonth;
  final List<double> expenseByMonth;

  const BuildingDashboardPage({
    super.key,
    required this.buildingName,
    required this.manager,
    required this.apartmentCount,
    required this.incomeByMonth,
    required this.expenseByMonth,
  });

  @override
  Widget build(BuildContext context) {
    double totalIncome = incomeByMonth.fold(0, (a, b) => a + b);
    double totalExpense = expenseByMonth.fold(0, (a, b) => a + b);
    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: Text('$buildingName Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Bina Genel Bilgileri
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buildingName,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text("Yönetici: $manager"),
                    Text("Daire Sayısı: $apartmentCount"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Finansal Özet Kartları
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard("Toplam Gelir", totalIncome, Colors.green),
                _summaryCard("Toplam Gider", totalExpense, Colors.red),
                _summaryCard("Bakiye", balance,
                    balance >= 0 ? Colors.blue : Colors.orange),
              ],
            ),
            const SizedBox(height: 20),

            /// Grafik
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Aylık Gelir - Gider Grafiği",
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 200, child: _BarChart()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                "${value.toStringAsFixed(2)} ₺",
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Basit Bar Chart (Gelir-Gider)
class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 12000, color: Colors.green),
            BarChartRodData(toY: 8000, color: Colors.red),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 14000, color: Colors.green),
            BarChartRodData(toY: 9000, color: Colors.red),
          ]),
          BarChartGroupData(x: 3, barRods: [
            BarChartRodData(toY: 10000, color: Colors.green),
            BarChartRodData(toY: 7000, color: Colors.red),
          ]),
        ],
      ),
    );
  }
}
