import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/building_provider.dart';
import 'package:yonetim_mibile_app/features/building/data/models/building_model.dart'; // senin BuildingResponse modelin buraya import edilmeli

class BuildingListPage extends ConsumerWidget {
  const BuildingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Binalarım")),
      body: buildingsAsync.when(
        data: (buildings) {
          if (buildings.isEmpty) {
            return const Center(child: Text("Henüz bir binanız yok."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final buildingResponse = buildings[index];
              final building = buildingResponse.building;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık + Rol
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            building.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(buildingResponse.role),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Adres
                      Text(
                        building.address.isNotEmpty
                            ? building.address
                            : "Adres bilgisi yok",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Kat / Daire Bilgisi
                      Row(
                        children: [
                          if (building.block != null)
                            Text("Blok: ${building.block}   "),
                          if (building.floorCount != null)
                            Text("Kat: ${building.floorCount}   "),
                          if (building.unitCount != null)
                            Text("Daire: ${building.unitCount}"),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Görsel
                      if (building.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            building.imageUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 48),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          debugPrint('Hata: $err');
          debugPrintStack(stackTrace: stack);
          return const Center(child: Text("Hata oluştu"));
        },
      ),
    );
  }
}
