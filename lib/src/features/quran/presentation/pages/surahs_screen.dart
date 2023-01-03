import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/quran/presentation/bloc/pin/bloc.dart';
import 'package:azkar/src/features/quran/presentation/bloc/surahs/bloc.dart';
import 'package:azkar/src/features/quran/presentation/widgets/surahs_meta.dart';
import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurahsPage extends StatelessWidget {
  const SurahsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SurahsBloc>(
      create: (context) => sl<SurahsBloc>()..add(GetSurahsEvent()),
      child: BlocBuilder<SurahsBloc, SurahsState>(
        builder: (context, surahState) {
          return BlocProvider<PinBloc>(
            create: (context) => sl<PinBloc>()..add(GetPinEvent()),
            child: BlocBuilder<PinBloc, PinState>(
              builder: (context, pinState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (surahState is SurahsLoadingState)
                        const Center(child: AppIndicator()),
                      if (surahState is SurahsLoadedState)
                        ...surahState.surahs.references!
                            .map((reference) => SurahsMeta(
                                  reference: reference,
                                  pinned: pinState is PinLoadedState
                                      ? pinState.pin!.surah == reference.number
                                      : false,
                                ))
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
