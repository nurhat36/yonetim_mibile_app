import 'package:dio/dio.dart';
import 'package:yonetim_mibile_app/core/dio_client.dart';
import 'models/building_model.dart';

class BuildingRepository {
  final DioClient _client;

  BuildingRepository(this._client);

  Future<List<BuildingResponse>> getUserBuildings(String token) async {
    final response = await _client.get("Buildings/user-buildings", token: token);

    final data = response.data;
    if (data is! List) {
      throw Exception("Beklenmeyen API yanıtı");
    }

    return data.map((item) => BuildingResponse.fromJson(item)).toList();
  }
}
