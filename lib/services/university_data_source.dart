import '../models/university_model.dart';
import 'base_network.dart';

class UniversityDataSource {
  static Future<List<University>> searchUniversities(String query) async {
    final data = await BaseNetwork.getData();
    final List<University> universities = [];

    for (var item in data) {
      if (item['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())) {
        universities.add(University.fromJson(item));
      }
    }

    return universities;
  }
}
