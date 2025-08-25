import 'package:yonetim_mibile_app/core/dio_client.dart';
import 'models/building_model.dart';

class BuildingRepository {
  final DioClient dioClient;

  BuildingRepository(this.dioClient);

  Future<List<BuildingModel>> getUserBuildings(String token) async {
    final response = await dioClient.get('/Buildings/user-buildings', token: token);
    final List data = response.data as List;
    return data.map((e) => BuildingModel.fromJson(e)).toList();
  }
}
