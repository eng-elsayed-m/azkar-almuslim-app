import 'package:azkar/src/core/models/category_model.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/utils/nav.dart';
import 'package:azkar/src/features/quotes/quotes_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          NV.nextScreen(context, QuotesScreen(category: category));
        },
        child: EntranceFader(
          duration: const Duration(milliseconds: 300),
          delay: const Duration(milliseconds: 100),
          offset: const Offset(50.0, 0.0),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Image.asset(
                'assets/images/card.png',
                fit: BoxFit.cover,
                // height: AppDimensions.normalize(200),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.normalize(33)),
                child: Text(
                  category.category!,
                  textWidthBasis: TextWidthBasis.parent,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontFamily: "A-Hemmat",
                      color: Colors.green.shade500),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ));
  }
}