import 'package:equatable/equatable.dart';

class SurahsEntity extends Equatable {
  int? count;
  List<ReferencesEntity>? references;

  SurahsEntity({this.references, this.count});

  @override
  List<Object?> get props => [count, references];
}

class ReferencesEntity extends Equatable {
  int? number;
  String? name;
  String? englishName;
  String? englishNameTranslation;
  int? numberOfAyahs;
  String? revelationType;

  ReferencesEntity(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.numberOfAyahs,
      this.revelationType});

  @override
  List<Object?> get props => [
        number,
        name,
        englishName,
        englishNameTranslation,
        numberOfAyahs,
        revelationType,
      ];
}
