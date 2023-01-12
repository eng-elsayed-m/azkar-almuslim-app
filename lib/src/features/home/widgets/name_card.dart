import 'dart:math';
import 'package:azkar/src/core/models/name_model.dart';
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
      duration: const Duration(seconds: 1),
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
    return switcherWidget();
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
    final size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: onTapped,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
              shape: front ? BoxShape.circle : BoxShape.rectangle,
              color: front
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withAlpha(100),
              borderRadius: front ? null : BorderRadius.circular(25)),
          width: size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: front
                ? Center(
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontWeight: FontWeight.w900,
                          shadows: const [Shadow(offset: Offset(5.0, 5.0))],
                          fontFamily: "ReemKufi",
                          color: Colors.white),
                    ),
                  )
                : Center(
                    child: Text(
                      name,
                      style: TextStyle(
                          fontFamily: "AmiriQuran",
                          height: 2,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
          ),
        ));
  }
}
