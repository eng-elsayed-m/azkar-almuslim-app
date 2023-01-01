import 'dart:async';

import 'package:azkar/src/features/quran/domain/entities/surah.dart';
import 'package:azkar/src/features/quran/domain/use_cases/get_surah.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/error_cases.dart';
import '../../../../../core/error/failures.dart';
part 'event.dart';
part 'state.dart';

class SurahBloc extends Bloc<SurahEvent, SurahState> {
  final GetSurahUC getSurahUseCase;
  SurahBloc({
    required this.getSurahUseCase,
  }) : super(SurahInitialState()) {
    on<GetSurahEvent>(_getSurah);
  }
  FutureOr<void> _getSurah(
      GetSurahEvent event, Emitter<SurahState> emit) async {
    emit(SurahLoadingState());
    final failureOrSections = await getSurahUseCase(
        number: event.number,
        audioEdition: event.audioEdition,
        translationEdition: event.translationEdition);
    emit(_mapFailureOrSectionsToState(failureOrSections));
  }

  SurahState _mapFailureOrSectionsToState(
      Either<Failure, SurahEntity> failureOrSections) {
    return failureOrSections.fold(
        (failure) => SurahErrorState(message: mapFailureToMessage(failure)),
        (surah) => SurahLoadedState(surah: surah));
  }
}
