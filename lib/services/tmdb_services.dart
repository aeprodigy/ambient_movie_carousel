
import 'dart:convert';

import 'package:http/http.dart' as http;

class TmdbServices {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = 'API_KEY';

  Future<List<dynamic>> fetchMovies() async {
    
      final response = await http.get(Uri.parse(
          '$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['results'];
      } else {
        throw Exception('cant load movies');
      }
    
  }
}
