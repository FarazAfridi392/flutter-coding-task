import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String _baseUrl = 'https://zenquotes.io/api/quotes/';

  Future<String> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return '${data[0]['q']} — ${data[0]['a']}';
    } else {
      throw Exception('Failed to load quote');
    }
  }
}
