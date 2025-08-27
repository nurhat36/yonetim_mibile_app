import 'package:flutter/material.dart';
import 'package:yonetim_mibile_app/features/building/data/models/building_model.dart';
// Dashboard sayfanı import et (dosya yolunu kendine göre düzenle)

import 'building_dashboard_page.dart';

class BuildingDetailPage extends StatelessWidget {
  final BuildingModel building;

  const BuildingDetailPage({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final toplamGelir =
    building.incomes.fold<double>(0, (sum, item) => sum + item.amount);
    final toplamGider =
    building.expenses.fold<double>(0, (sum, item) => sum + item.amount);
    final aidatBorcu = building.userDebts
        .where((d) => !d.isPaid)
        .fold<double>(0, (sum, d) => sum + d.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(building.name),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          // Örneğin BuildingDetailPage içinde bir buton
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuildingDashboardPage(
                      buildingId: building.id
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text("Dashboard'u Görüntüle"),
          ),

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (building.imageUrl != null && building.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  "http://10.0.2.2:5268${building.imageUrl!}",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    building.address.isNotEmpty
                        ? building.address
                        : "Adres bilgisi yok",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            Text("Finansal Durum",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            _buildFinanceCard(Icons.attach_money, "Toplam Gelir",
                "$toplamGelir ₺", Colors.green),
            _buildFinanceCard(
                Icons.money_off, "Toplam Gider", "$toplamGider ₺", Colors.red),
            _buildFinanceCard(
                Icons.account_balance_wallet,
                "Aidat Borcum",
                "$aidatBorcu ₺",
                aidatBorcu > 0 ? Colors.orange : Colors.blue),

            const Divider(height: 32),

            Text("Gelirler",
                style: Theme.of(context).textTheme.titleLarge),
            ...building.incomes.map((i) => ListTile(
              leading:
              const Icon(Icons.arrow_circle_up, color: Colors.green),
              title: Text(i.name),
              trailing: Text("${i.amount} ₺"),
            )),

            const Divider(height: 32),

            Text("Giderler",
                style: Theme.of(context).textTheme.titleLarge),
            ...building.expenses.map((e) => ListTile(
              leading:
              const Icon(Icons.arrow_circle_down, color: Colors.red),
              title: Text(e.name),
              trailing: Text("${e.amount} ₺"),
            )),

            const Divider(height: 32),

            Text("Aidat Borçlarım",
                style: Theme.of(context).textTheme.titleLarge),
            ...building.userDebts.map((d) => ListTile(
              leading: Icon(
                  d.isPaid ? Icons.check_circle : Icons.error,
                  color: d.isPaid ? Colors.green : Colors.orange),
              title: Text(d.description),
              trailing: Text("${d.amount} ₺"),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFinanceCard(
      IconData icon, String label, String value, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 16, color: color)),
      ),
    );
  }
}
