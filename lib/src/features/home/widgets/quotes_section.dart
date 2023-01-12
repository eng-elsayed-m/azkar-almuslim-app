import 'package:azkar/src/core/quotes_bloc/bloc.dart';
import 'package:azkar/src/core/utils/configs/configs.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/widgets/app_loader.dart';
import 'package:azkar/src/features/home/widgets/category_card.dart';
import 'package:azkar/src/features/home/widgets/title_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuotesSection extends StatefulWidget {
  const QuotesSection({
    Key? key,
  }) : super(key: key);

  @override
  State<QuotesSection> createState() => _QuotesSectionState();
}

class _QuotesSectionState extends State<QuotesSection> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dSize = MediaQuery.of(context).size;
    return BlocProvider<QuotesBloc>(
      create: (context) => QuotesBloc()..add(const LoadQuotes()),
      child: BlocBuilder<QuotesBloc, QuotesState>(
        builder: (context, state) {
          if (state is QuotesLoading) {
            return const Center(child: AppIndicator());
          } else if (state is QuotesLoadSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextField(
                      // textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: theme.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      onChanged: (value) => setState(() {
                        query = value;
                      }),
                      decoration: InputDecoration(
                          hintText: "الأذكــار",
                          border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.search,
                            size: 35,
                            color: theme.primaryColor,
                          )),
                    ),
                  ),
                ),

                Expanded(
                  child: EntranceFader(
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 350),
                    offset: const Offset(0.0, 50.0),
                    child: GridView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                      children: state.quotes
                          .where((element) => element.category!.contains(query))
                          .map((e) => CategoryCard(category: e))
                          .toList(),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: AppDimensions.normalize(20),
                // ),
              ],
            );
          } else if (state is QuotesLoadFailed) {
            return Center(child: Text(state.exception.toString()));
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
