import 'dart:convert';
import 'package:azkar/src/features/quran/data/models/pin_model.dart';
import 'package:azkar/src/features/quran/data/models/surah_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import '../models/surahs_model.dart';

abstract class QuranDataSource {
  Future<Surahs> fetchSurahs();
  Future<PinModel?> setPin(PinModel pin);
  Future<PinModel?> getPin();
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

  @override
  Future<PinModel?> setPin(PinModel pin) async {
    final sh = await SharedPreferences.getInstance();
    print(pin.toJson());
    sh.setString("pin", jsonEncode(pin.toJson()));
    return pin;
  }

  @override
  Future<PinModel?> getPin() async {
    final sh = await SharedPreferences.getInstance();
    final pinString = sh.getString('pin');
    if (pinString == null) return null;
    final jsonPin = jsonDecode(pinString);
    print(pinString);
    return PinModel.fromJson(jsonPin);
  }
}
