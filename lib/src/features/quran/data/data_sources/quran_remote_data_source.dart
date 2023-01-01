import 'dart:convert';
import 'package:azkar/src/features/quran/data/models/surah_model.dart';

import '../../../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/surahs_model.dart';

abstract class QuranDataSource {
  Future<Surahs> fetchSurahs();
  Future<Surah> fetchSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition});
  Future<List<Edition>> fetchEditions();
}

class QuranDataSourceImpl implements QuranDataSource {
  final http.Client client;

  QuranDataSourceImpl({required this.client});
  @override
  Future<Surahs> fetchSurahs() async {
    final response = await client.get(
      Uri.parse("http://api.alquran.cloud/v1/meta"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map decodedResponse = json.decode(response.body);
      if (decodedResponse.isEmpty) throw ServerException();
      final surahsJson = decodedResponse['data']['surahs'];

      return Surahs.fromJson(surahsJson!);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Surah> fetchSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition}) async {
    final String editions =
        "editions/ar.asad,$audioEdition,$translationEdition";
    print("http://api.alquran.cloud/v1/surah/$number/$editions");
    final response = await client.get(
      Uri.parse("http://api.alquran.cloud/v1/surah/$number/$editions"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);
      if (decodedResponse.isEmpty) throw ServerException();
      return Surah.fromJson(decodedResponse);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Edition>> fetchEditions() async {
    final response = await client.get(
      Uri.parse("http://api.alquran.cloud/v1/edition"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List decodedResponse = json.decode(response.body)['data'];
      if (decodedResponse.isEmpty) throw ServerException();
      print(decodedResponse);
      return decodedResponse
          .map((edition) => Edition.fromJson(edition))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
