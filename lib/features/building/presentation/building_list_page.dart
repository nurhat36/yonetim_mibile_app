import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/building_provider.dart';

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
            itemCount: buildings.length,
            itemBuilder: (context, index) {
              final building = buildings[index];
              return ListTile(
                title: Text(building.name),
                subtitle: Text(building.address),
                onTap: () {
                  // Detay sayfasına yönlendirebilirsin
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          // Hata terminale yazdırılır
          debugPrint('Hata: $err');
          debugPrintStack(stackTrace: stack);

          // UI'da kullanıcıya gösterilir
          return Center(child: Text("Hata oluştu"));
        }
        ,
      ),
    );
  }
}
