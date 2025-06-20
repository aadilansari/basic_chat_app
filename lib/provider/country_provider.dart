import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final countryListProvider = FutureProvider<List<String>>((ref) async {
  final res = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
  final List data = jsonDecode(res.body);
  return data.map((e) => e['name']['common'].toString()).toList()..sort();
});
