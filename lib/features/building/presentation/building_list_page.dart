import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/building_provider.dart';
import 'package:yonetim_mibile_app/features/building/data/models/building_model.dart';

import 'building_detail_page.dart';

class BuildingListPage extends ConsumerWidget {
  const BuildingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buildingsAsync = ref.watch(buildingProvider);
    const String apiBaseUrl = "http://10.0.2.2:5268";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Binalarım"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Arama işlevselliği eklenebilir
            },
          ),
        ],
      ),
      body: buildingsAsync.when(
        data: (buildings) {
          if (buildings.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(buildingProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: buildings.length,
              itemBuilder: (context, index) {
                final buildingResponse = buildings[index];
                final building = buildingResponse.building;

                return _buildBuildingCard(
                  context,
                  buildingResponse,
                  building,
                  apiBaseUrl,
                );
              },
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (err, stack) => _buildErrorState(err, stack),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni bina ekleme sayfasına yönlendirme
        },
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBuildingCard(
      BuildContext context,
      BuildingResponse buildingResponse,
      BuildingModel building,
      String apiBaseUrl,
      ) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Bina detay sayfasına yönlendirme
        },
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Görsel bölümü
              Stack(
                children: [
                  // Bina görseli
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.grey[200],
                    ),
                    child: building.imageUrl != null && building.imageUrl!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        apiBaseUrl + building.imageUrl!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.apartment, size: 60, color: Colors.grey),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                        : const Icon(Icons.apartment, size: 60, color: Colors.grey),
                  ),

                  // Rol etiketi
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getRoleColor(buildingResponse.role),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        buildingResponse.role.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // İçerik bölümü
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bina adı
                    Text(
                      building.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Adres
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            building.address.isNotEmpty ? building.address : "Adres bilgisi yok",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Bina özellikleri
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (building.block != null)
                          _buildFeatureItem(Icons.account_balance, "Blok", building.block.toString()),

                        if (building.floorCount != null)
                          _buildFeatureItem(Icons.layers, "Kat", building.floorCount.toString()),

                        if (building.unitCount != null)
                          _buildFeatureItem(Icons.home, "Daire", building.unitCount.toString()),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Detay butonu
                    SizedBox(
                      width: double.infinity,
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BuildingDetailPage(building: building),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Detayları Görüntüle"),
                      ),

                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apartment, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            "Henüz bir binanız yok",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Yeni bina eklemek için aşağıdaki butonu kullanın",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            "Binalar yükleniyor...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object err, StackTrace stack) {
    debugPrint('Hata: $err');
    debugPrintStack(stackTrace: stack);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text(
            "Bir hata oluştu",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Lütfen daha sonra tekrar deneyin",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Yeniden deneme işlevselliği
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
            child: const Text("Yeniden Dene"),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'yönetici':
        return Colors.red;
      case 'kiracı':
        return Colors.green;
      case 'sakin':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}