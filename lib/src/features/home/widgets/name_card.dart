import 'dart:math';

import 'package:azkar/src/core/models/name_model.dart';
import 'package:azkar/src/core/utils/configs/app_dimensions.dart';
import 'package:azkar/src/core/utils/entrance_fader.dart';
import 'package:azkar/src/core/utils/nav.dart';
import 'package:azkar/src/features/quotes/quotes_screen.dart';
import 'package:flutter/material.dart';

class NameCard extends StatefulWidget {
  final NameModel name;

  const NameCard({Key? key, required this.name}) : super(key: key);

  @override
  State<NameCard> createState() => _NameCardState();
}

class _NameCardState extends State<NameCard> {
  late final CardWidget frontWidget;
  late final CardWidget backWidget;

  bool _isShowingFront = true;

  Widget switcherWidget() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: _isShowingFront ? 0.0 : pi),
      duration: Duration(seconds: 1),
      curve: Curves.linearToEaseOut,
      builder: (context, double value, child) {
        final isShowingBack = value > pi / 2.0;
        final toDisplay = isShowingBack ? backWidget : frontWidget;
        return Transform(
          transform: Matrix4.identity()
            ..scale(0.7, 0.7)
            ..rotateY(value),
          alignment: Alignment.center,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(isShowingBack ? pi : 0.0),
            child: toDisplay,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    frontWidget = CardWidget(
      front: true,
      key: ValueKey(widget.name.name),
      name: widget.name.name!,
      onTapped: () {
        setState(() => _isShowingFront = false);
      },
    );

    backWidget = CardWidget(
      front: false,
      key: ValueKey(widget.name.text),
      name: widget.name.text!,
      onTapped: () {
        setState(() => _isShowingFront = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return switcherWidget();
    // return InkWell(
    //     onTap: () {},
    //     child: EntranceFader(
    //         duration: const Duration(milliseconds: 300),
    //         delay: const Duration(milliseconds: 100),
    //         offset: const Offset(50.0, 0.0),
    //         child: Container(
    //           width: AppDimensions.normalize(100),
    //           height: AppDimensions.normalize(100),
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             // border: Border.all(
    //             //     strokeAlign: StrokeAlign.outside,
    //             //     width: 3,
    //             //     style: BorderStyle.solid),
    //             boxShadow: [
    //               BoxShadow(
    //                   offset: Offset(5.0, 5.0),
    //                   color: Colors.amber.shade800.withOpacity(0.3))
    //             ],
    //
    //             gradient:
    //                 RadialGradient(center: Alignment.center, stops: const [
    //               0.4,
    //               0.6,
    //               0.8,
    //               0.9,
    //             ], colors: [
    //               Colors.white,
    //               Colors.green.shade100,
    //               Colors.green.shade200,
    //               Colors.green.shade300,
    //             ]),
    //           ),
    //           child: Padding(
    //             padding: EdgeInsets.all(AppDimensions.normalize(15)),
    //             child: FittedBox(
    //               child: Text(
    //                 widget.name.name!,
    //                 textWidthBasis: TextWidthBasis.parent,
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w900,
    //                     shadows: const [Shadow(offset: Offset(0.0, 1.0))],
    //                     fontFamily: "Aldhabi",
    //                     color: Colors.green.shade500),
    //                 textAlign: TextAlign.center,
    //                 softWrap: true,
    //               ),
    //             ),
    //           ),
    //         )));
  }
}

class CardWidget extends StatelessWidget {
  final String name;
  final bool front;
  final VoidCallback onTapped;

  const CardWidget({
    Key? key,
    required this.name,
    required this.onTapped,
    required this.front,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTapped,
        child: Container(
          width: AppDimensions.normalize(200),
          decoration: !front
              ? null
              : BoxDecoration(
                  shape: front ? BoxShape.circle : BoxShape.rectangle,
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 15.0,
                      spreadRadius: 2,
                    )
                  ],
                ),
          child: front
              ? FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        shadows: const [Shadow(offset: Offset(0.0, 1.0))],
                        fontFamily: "Aldhabi",
                        color: Colors.green.shade500),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name,
                      textWidthBasis: TextWidthBasis.parent,
                      textScaleFactor: 1.5,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            fontFamily: "A-Hemmat",
                          ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ),
        ));
  }
}