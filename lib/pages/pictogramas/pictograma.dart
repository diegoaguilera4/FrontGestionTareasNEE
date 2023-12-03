import 'dart:convert';
import 'package:http/http.dart';

class PictogramResult {
  final int id;
  final String keyword;
  final String imageUrl;

  PictogramResult({
    required this.id,
    required this.keyword,
    required this.imageUrl,
  });

  //metodo imprimir objeto
  @override
  String toString() {
    return 'PictogramResult{id: $id, keyword: $keyword, imageUrl: $imageUrl}';
  }
}

Future<List<PictogramResult>> searchPictograms(String searchTerm) async {
  final Uri url =
      Uri.parse('https://api.arasaac.org/v1/pictograms/es/search/$searchTerm');

  final Response response = await get(url);
  if (response.statusCode == 200 ) {
    final List<dynamic> dataList = jsonDecode(response.body);

    // Convertir la lista de datos en una lista de objetos PictogramResult
    final List<PictogramResult> results = dataList
        .map((data) => PictogramResult(
              id: data['_id'],
              keyword: data['keywords'][0]['keyword'],
              imageUrl:
                  'https://static.arasaac.org/pictograms/${data['_id']}/${data['_id']}_500.png',
            ))
        .toList();
    return results;
  } else {
    throw Exception('Failed to fetch pictograms');
  }
}
