import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yonetim_mibile_app/core/secure_storage.dart';
import '../data/building_repository.dart';
import '../data/models/building_model.dart';
import 'package:yonetim_mibile_app/core/dio_client.dart';

// Repository provider
final buildingRepositoryProvider = Provider((ref) {
  return BuildingRepository(DioClient());
});

// Auth token provider (FlutterSecureStorage kullanıyor)
final authTokenProvider = FutureProvider<String?>((ref) async {
  return await SecureStorage.getToken(); // token'ı oku
});

// Building list provider (token ile API çağrısı)
final buildingProvider = FutureProvider<List<BuildingModel>>((ref) async {
  final repo = ref.watch(buildingRepositoryProvider);

  final token = await ref.watch(authTokenProvider.future);
  if (token == null) {
    throw Exception("Token bulunamadı, giriş yapmalısınız");
  }

  return repo.getUserBuildings(token);
});
