import 'package:equatable/equatable.dart';

class PinEntity extends Equatable {
  String? title;
  int? surah;
  int? ayah;

  PinEntity({this.title, this.surah, this.ayah});

  @override
  List<Object?> get props => [title, surah, ayah];
}
