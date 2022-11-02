import 'package:azkar/src/core/names_bloc/bloc.dart';
import 'package:azkar/src/core/utils/configs/configs.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
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
  String query = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dSize = MediaQuery.of(context).size;
    return BlocProvider<NamesBloc>(
      create: (context) => NamesBloc()..add(const LoadNames()),
      child: BlocBuilder<NamesBloc, NamesState>(
        builder: (context, state) {
          if (state is NamesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NamesLoadSuccess) {
            return SizedBox(
              height: dSize.height * 0.3,
              child: EntranceFader(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 350),
                offset: const Offset(0.0, 50.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  addAutomaticKeepAlives: true,
                  padding: const EdgeInsets.all(10.0),
                  children: state.names
                      .where((element) => element.name!.contains(query))
                      .map((e) => NameCard(name: e))
                      .toList(),
                ),
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