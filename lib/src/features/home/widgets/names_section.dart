import 'package:azkar/src/core/names_bloc/bloc.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/home/widgets/name_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NamesSection extends StatefulWidget {
  const NamesSection({
    Key? key,
  }) : super(key: key);

  @override
  State<NamesSection> createState() => _NamesSectionState();
}

class _NamesSectionState extends State<NamesSection> {
  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    return BlocProvider<NamesBloc>(
      create: (context) => NamesBloc()..add(const LoadNames()),
      child: BlocBuilder<NamesBloc, NamesState>(
        builder: (context, state) {
          if (state is NamesLoading) {
            return const Center(child: AppIndicator());
          } else if (state is NamesLoadSuccess) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide())),
              height: dSize.height * 0.22,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,

                addAutomaticKeepAlives: true,
                // padding: EdgeInsets.symmetric(horizontal: 1),
                children: state.names
                    .map((e) => EntranceFader(
                        delay: Duration(
                            milliseconds: 100 + (20 * state.names.indexOf(e))),
                        duration: const Duration(milliseconds: 350),
                        offset: const Offset(0.0, 50.0),
                        child: NameCard(name: e)))
                    .toList(),
              ),
            );
          } else if (state is NamesLoadFailed) {
            return Center(child: Text(state.exception.toString()));
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
