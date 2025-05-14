import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRoute<T> {
  final Widget child;
  final Duration duration;
  
  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    super.settings,
  }) : super(fullscreenDialog: false);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class SlideUpPageRoute<T> extends PageRoute<T> {
  final Widget child;
  final Duration duration;
  
  SlideUpPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  }) : super(settings: settings, fullscreenDialog: false);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuart,
      )),
      child: child,
    );
  }
}