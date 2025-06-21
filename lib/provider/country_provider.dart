import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final selectedCountryProvider = StateProvider<String?>((ref) => null);

final countryListProvider = FutureProvider<List<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();

  // 🔁 Try to load cached countries
  final cachedJson = prefs.getString('cached_countries');
  if (cachedJson != null) {
    final List cachedList = jsonDecode(cachedJson);
    return cachedList.cast<String>();
  }

  // 🌐 Fetch from API
  //https://restcountries.com/v3.1/independent?status=true
  final res = await http.get(Uri.parse('https://restcountries.com/v3.1/independent?status=true'));
  if (res.statusCode != 200) throw Exception("Failed to load countries");

  final List data = jsonDecode(res.body);
  final countryList = data
      .map((e) => e['name']['common'].toString())
      .toList()
    ..sort();

  // 💾 Cache the result
  await prefs.setString('cached_countries', jsonEncode(countryList));
  return countryList;
});