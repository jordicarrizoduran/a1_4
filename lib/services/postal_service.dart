import 'package:http/http.dart' as http;

import '../models/postal_codes.dart';

class PostalService {
  String codi = '';

  Future<CodiPostals> fetchData(String code) async {
    var response = await http.get(Uri.parse("https://api.zippopotam.us/es/$code"));
    final codiPostals = codiPostalsFromJson(response.body);
    return codiPostals;
  }

}