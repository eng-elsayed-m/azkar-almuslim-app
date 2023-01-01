import 'package:azkar/src/features/quran/data/models/surah_model.dart';
import 'package:equatable/equatable.dart';

class SurahEntity extends Equatable {
  int? code;
  String? status;
  DataEntity? mainData;
  DataEntity? translationData;
  DataEntity? audioData;

  SurahEntity(
      {this.code,
      this.status,
      this.mainData,
      this.translationData,
      this.audioData});

  @override
  List<Object?> get props => [code, audioData, translationData, status];
}

class DataEntity extends Equatable {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  String? revelationType;
  int? numberOfAyahs;
  List<Ayahs>? ayahs;
  Edition? edition;

  DataEntity(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.revelationType,
      this.numberOfAyahs,
      this.ayahs,
      this.edition});

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        revelationType,
        numberOfAyahs,
        ayahs,
        edition
      ];
}

class AyahsEntity extends Equatable {
  int? number;
  String? text;
  String? audio;
  List? audioSecondary;
  int? numberInSurah;
  int? juz;
  int? manzil;
  int? page;
  int? ruku;
  int? hizbQuarter;
  bool? sajda;

  AyahsEntity(
      {this.number,
      this.text,
      this.numberInSurah,
      this.audio,
      this.audioSecondary,
      this.juz,
      this.manzil,
      this.page,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

  @override
  List<Object?> get props => [
        number,
        text,
        numberInSurah,
        audio,
        audioSecondary,
        juz,
        manzil,
        page,
        ruku,
        hizbQuarter,
        sajda
      ];

  // Ayahs.fromJson(Map<String, dynamic> json) {
  //   number = json['number'];
  //   text = json['text'];
  //   numberInSurah = json['numberInSurah'];
  //   juz = json['juz'];
  //   manzil = json['manzil'];
  //   page = json['page'];
  //   ruku = json['ruku'];
  //   hizbQuarter = json['hizbQuarter'];
  //   sajda = json['sajda'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['number'] = this.number;
  //   data['text'] = this.text;
  //   data['numberInSurah'] = this.numberInSurah;
  //   data['juz'] = this.juz;
  //   data['manzil'] = this.manzil;
  //   data['page'] = this.page;
  //   data['ruku'] = this.ruku;
  //   data['hizbQuarter'] = this.hizbQuarter;
  //   data['sajda'] = this.sajda;
  //   return data;
  // }
}

class EditionEntity extends Equatable {
  String? identifier;
  String? language;
  String? name;
  String? englishName;
  String? format;
  String? type;
  String? direction;

  EditionEntity(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction});

  @override
  List<Object?> get props =>
      [identifier, language, name, englishName, format, type, direction];
}
