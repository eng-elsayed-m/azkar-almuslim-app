import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:flutter/material.dart';

class TitleCard extends StatelessWidget {
  final Widget title;
  const TitleCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final dSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Padding(
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
                child: title),
          ),
        ],
      ),
    );
  }
}
