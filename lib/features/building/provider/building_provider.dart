import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/building_repository.dart';
import '../data/models/building_model.dart';
import 'package:yonetim_mibile_app/core/dio_client.dart';

final buildingRepositoryProvider = Provider((ref) {
  return BuildingRepository(DioClient());
});

final buildingProvider = FutureProvider<List<BuildingModel>>((ref) async {
  final repo = ref.watch(buildingRepositoryProvider);
  return repo.getUserBuildings();
});
