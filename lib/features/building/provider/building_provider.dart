import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_mibile_app/core/secure_storage.dart';
import '../data/building_repository.dart';
import '../data/models/building_dashboard.dart';
import '../data/models/building_model.dart';

import 'package:yonetim_mibile_app/core/dio_client.dart';

// Repository provider
final buildingRepositoryProvider = Provider((ref) {
  return BuildingRepository(DioClient());
});

// Token provider
final authTokenProvider = FutureProvider<String?>((ref) async {
  return await SecureStorage.getToken();
});

// Building list provider
final buildingProvider = FutureProvider<List<BuildingResponse>>((ref) async {
  final repo = ref.watch(buildingRepositoryProvider);

  final token = await ref.watch(authTokenProvider.future);
  if (token == null) {
    throw Exception("Token bulunamadı, giriş yapmalısınız");
  }

  // Hata vermemesi için repo artık List<BuildingResponse> dönüyor
  return await repo.getUserBuildings(token);
});
final dashboardProvider =
FutureProvider.family<BuildingDashboard, int>((ref, buildingId) async {
  final repo = ref.watch(buildingRepositoryProvider);
  final token = await ref.watch(authTokenProvider.future);
  if (token == null) throw Exception("Token bulunamadı");

  return repo.getDashboard(buildingId, token);
});
