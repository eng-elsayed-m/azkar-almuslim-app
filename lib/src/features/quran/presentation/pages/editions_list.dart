import 'package:azkar/src/features/quran/domain/entities/surah.dart';
import 'package:azkar/src/features/quran/presentation/bloc/edition/bloc.dart';
import 'package:azkar/src/features/quran/presentation/bloc/surah/bloc.dart';
import 'package:azkar/src/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditionsList extends StatefulWidget {
  final int number;
  const EditionsList({super.key, required this.number});

  @override
  State<EditionsList> createState() => _EditionsListState();
}

class _EditionsListState extends State<EditionsList> {
  EditionEntity? textEdition;
  EditionEntity? audioEdition;
  void onChange() => context.read<SurahBloc>().add(GetSurahEvent(
      number: widget.number,
      audioEdition:
          audioEdition == null ? 'quran-uthmani' : audioEdition!.identifier!,
      translationEdition:
          textEdition == null ? 'ar.alafasy' : textEdition!.identifier!));
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditionBloc>(
      create: (context) {
        return sl<EditionBloc>()..add(const GetEditionEvent());
      },
      child: BlocBuilder<EditionBloc, EditionState>(
        builder: (context, state) {
          if (state is EditionLoadedState) {
            textEdition ??= state.edition
                .firstWhere((element) => element.identifier == 'quran-uthmani');
            audioEdition ??= state.edition
                .firstWhere((element) => element.identifier == 'ar.alafasy');
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<EditionEntity>(
                  icon: const Icon(Icons.language),
                  value: textEdition,
                  alignment: Alignment.center,
                  isDense: true,
                  isExpanded: true,
                  hint: const Text(
                    "Language",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: state is EditionLoadedState
                      ? state.edition
                          .where((element) {
                            return element.format == "text";
                          })
                          .map((edition) => DropdownMenuItem<EditionEntity>(
                                alignment: Alignment.center,
                                value: edition,
                                child: Text(
                                    "${edition.name} - ${edition.type} - ${edition.language!.toUpperCase()}",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList()
                      : <DropdownMenuItem<EditionEntity>>[],
                  onChanged: (value) {
                    setState(() {
                      textEdition = value;
                    });
                    onChange();
                  }),
              const SizedBox(height: 20),
              DropdownButton<EditionEntity>(
                  icon: const Icon(Icons.audiotrack_outlined),
                  value: audioEdition,
                  isDense: true,
                  alignment: Alignment.center,
                  isExpanded: true,
                  hint: const Text(
                    "Audio",
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: state is EditionLoadedState
                      ? state.edition
                          .where((element) {
                            return element.format == "audio";
                          })
                          .map((edition) => DropdownMenuItem<EditionEntity>(
                              alignment: Alignment.center,
                              value: edition,
                              child: Text(
                                "${edition.name} - ${edition.type} - ${edition.language!.toUpperCase()}",
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                              )))
                          .toList()
                      : <DropdownMenuItem<EditionEntity>>[],
                  onChanged: (value) {
                    setState(() {
                      audioEdition = value;
                    });
                    onChange();
                  }),
            ],
          );
        },
      ),
    );
  }
}
