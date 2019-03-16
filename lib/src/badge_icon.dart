import 'package:flutter/material.dart';
import 'package:badges/src/badge_position.dart';
import 'package:badges/src/badge_shape.dart';
import 'package:badges/src/badge_positions.dart';

class BadgeIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final int itemCount;
  final Color badgeColor;
  final IconData icon;
  final bool hideZeroCount;
  final bool toAnimate;
  final BadgePosition position;
  final BadgeShape shape;
  final TextStyle textStyle;
  final EdgeInsets badgePadding;
  final EdgeInsets iconPadding;
  final Duration animationDuration;

  BadgeIcon(
      {Key key,
      @required this.itemCount,
      @required this.icon,
      this.onPressed,
      this.hideZeroCount = true,
      this.badgeColor = Colors.red,
      this.toAnimate = true,
      this.position = BadgePosition.topRight,
      this.shape = BadgeShape.circle,
      this.textStyle = const TextStyle(
        fontSize: 13.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      this.badgePadding = const EdgeInsets.all(5.0),
      this.iconPadding = const EdgeInsets.all(5.0),
      this.animationDuration: const Duration(milliseconds: 500)})
      : assert(itemCount >= 0),
        assert(badgeColor != null),
        super(key: key);

  @override
  BadgeIconState createState() {
    return BadgeIconState();
  }
}

class BadgeIconState extends State<BadgeIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  final Tween<Offset> _badgePositionTween = Tween(
    begin: const Offset(-0.5, 0.9),
    end: const Offset(0.0, 0.0),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.hideZeroCount && widget.itemCount == 0) {
      return Padding(
        padding: widget.iconPadding,
        child: Icon(
          widget.icon,
        ),
      );
    }

    return Stack(
      overflow: Overflow.visible,
      children: [
        Padding(
          padding: widget.iconPadding,
          child: Icon(widget.icon),
        ),
        BadgePositioned(
          position: widget.position,
          child: widget.toAnimate
              ? SlideTransition(
                  position: _badgePositionTween.animate(_animation),
                  child: _getBadge())
              : _getBadge(),
        ),
      ],
    );
  }

  Widget _getBadge() {
    return Material(
        type: widget.shape == BadgeShape.circle
            ? MaterialType.circle
            : MaterialType.card,
        elevation: 2.0,
        color: widget.badgeColor,
        child: Padding(
          padding: widget.badgePadding,
          child: Text(
            widget.itemCount.toString(),
            style: widget.textStyle,
          ),
        ));
  }

  @override
  void didUpdateWidget(BadgeIcon oldWidget) {
    if (widget.itemCount != oldWidget.itemCount) {
      _animationController.reset();
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _animationController.forward();
  }
}
