import '../../domain/entities/surahs.dart';

class Surahs extends SurahsEntity {
  Surahs({int? count, List<References>? references})
      : super(count: count, references: references);

  Surahs.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['references'] != null) {
      references = [];
      json['references'].forEach((v) {
        references!.add(References.fromJson(v));
      });
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['count'] = count;
  //   if (references != null) {
  //     data['references'] = references!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class References extends ReferencesEntity {
  References(
      {int? number,
      String? name,
      String? englishName,
      String? englishNameTranslation,
      int? numberOfAyahs,
      String? revelationType})
      : super(
          number: number,
          name: name,
          englishName: englishName,
          englishNameTranslation: englishNameTranslation,
          numberOfAyahs: numberOfAyahs,
          revelationType: revelationType,
        );

  References.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    englishName = json['englishName'];
    englishNameTranslation = json['englishNameTranslation'];
    numberOfAyahs = json['numberOfAyahs'];
    revelationType = json['revelationType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['name'] = name;
    data['englishName'] = englishName;
    data['englishNameTranslation'] = englishNameTranslation;
    data['numberOfAyahs'] = numberOfAyahs;
    data['revelationType'] = revelationType;
    return data;
  }

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
