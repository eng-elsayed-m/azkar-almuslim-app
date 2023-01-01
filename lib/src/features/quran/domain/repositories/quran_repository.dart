import 'package:azkar/src/features/quran/data/models/surah_model.dart';
import 'package:azkar/src/features/quran/domain/entities/surah.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/surahs.dart';

abstract class QuranRepository {
  Future<Either<Failure, SurahsEntity>> getSurahs();
  Future<Either<Failure, SurahEntity>> getSurah(
      {required int number,
      required String audioEdition,
      required String translationEdition});
  Future<Either<Failure, List<Edition>>> getEditions();
}
