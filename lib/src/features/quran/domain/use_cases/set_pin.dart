import 'package:azkar/src/features/quran/data/models/pin_model.dart';
import 'package:azkar/src/features/quran/domain/entities/pin.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/quran_repository.dart';

class SetPinUC {
  final QuranRepository repository;

  SetPinUC(this.repository);

  Future<Either<Failure, PinEntity>> call(PinModel pin) async {
    return await repository.setPin(pin);
  }
}
