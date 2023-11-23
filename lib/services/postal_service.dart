import 'package:http/http.dart' as http;

import '../models/postal_codes.dart';

class PostalService {
  String codi = '';
  String responseData ='';
  String placeName='';

  Future<CodiPostals> fetchData(newCodi) async {
    var response = await http.get(Uri.parse("https://api.zippopotam.us/es/ct/$codi"));
    final codiPostals = codiPostalsFromJson(response.body);
    return codiPostals;
  }

  void updateCodi(String newCodi) {
    codi = newCodi;
  }
}