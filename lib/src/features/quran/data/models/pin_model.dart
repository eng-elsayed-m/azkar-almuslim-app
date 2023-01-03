import 'package:azkar/src/features/quran/domain/entities/pin.dart';

class PinModel extends PinEntity {
  PinModel({
    String? title,
    int? surah,
    int? ayah,
  }) : super(title: title, surah: surah, ayah: ayah);

  PinModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    surah = json['surah'];
    ayah = json['ayah'];
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "surah": surah, "ayah": ayah};
  }
}
