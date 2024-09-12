import 'package:coding_task/services/quote_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quoteProvider = FutureProvider<String>((ref) async {
  final quoteService = QuoteService();
  return await quoteService.fetchQuote();
});
