import 'package:azkar/src/core/quotes_bloc/bloc.dart';
import 'package:azkar/src/core/utils/configs/configs.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/features/home/widgets/category_card.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuotesLoadSuccess) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: AppDimensions.normalize(150),
                    bottom: AppDimensions.normalize(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      EntranceFader(
                        delay: const Duration(milliseconds: 100),
                        duration: const Duration(milliseconds: 350),
                        offset: const Offset(0.0, 32.0),
                        child: Image.asset(
                          'assets/images/title-card.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: dSize.width * 0.28,
                        // height: AppDimensions.normalize(55),
                        left: dSize.width * 0.033,
                        child: EntranceFader(
                          delay: const Duration(milliseconds: 100),
                          duration: const Duration(milliseconds: 350),
                          offset: const Offset(0.0, 32.0),
                          child: TextField(
                            // textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            style: theme.textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.scaffoldBackgroundColor,
                            ),
                            onChanged: (value) => setState(() {
                              query = value;
                            }),
                            decoration: InputDecoration(
                                hintText: "الأذكــــــار",
                                hintStyle:
                                    theme.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontFamily: "A-Hemmat",
                                  color: theme.scaffoldBackgroundColor,
                                ),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 35,
                                  color: theme.scaffoldBackgroundColor,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 350),
                  offset: const Offset(0.0, 32.0),
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 3,
                    height: 0,
                  ),
                ),
                EntranceFader(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 350),
                  offset: const Offset(0.0, 50.0),
                  child: SizedBox(
                    height: dSize.height * 0.53,
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