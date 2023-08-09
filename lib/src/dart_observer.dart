import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_smartlook/wireframe/widget_scraper/smartlook_helper_controller.dart';

/// Tracks pushed, popped Screens and [AlertDialog]
class SmartlookObserver extends NavigatorObserver {
  final bool isTrackingNavigationEvents;

  SmartlookObserver({this.isTrackingNavigationEvents = true});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    SmartlookHelperController.changeTransitioningState(true);

    super.didPush(route, previousRoute);

    final routeName = _handleRouteNameWithTransitionEnd(route);
    if (routeName != null && isTrackingNavigationEvents) {
      Smartlook.instance.trackNavigationEnter(routeName);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    SmartlookHelperController.changeTransitioningState(true);

    super.didPop(route, previousRoute);

    final routeName = _handleRouteNameWithTransitionEnd(route);
    if (routeName != null && isTrackingNavigationEvents) {
      Smartlook.instance.trackNavigationExit(routeName);
    }
  }

  String? _handleRouteNameWithTransitionEnd(Route<dynamic> route) {
    String? routeName = route.settings.name;

    if (navigator != null) {
      if (routeName == null && route is MaterialPageRoute) {
        final widget = route.builder(navigator!.context);
        routeName = widget.runtimeType.toString();
      }

      if (route is ModalRoute) {
        _addAnimationListener(route);
      }
    }

    return routeName;
  }

  void _addAnimationListener(ModalRoute<dynamic> route) {
    final animation = route.animation;

    late void Function(AnimationStatus) listener;

    listener = (AnimationStatus status) {
      if ((status == AnimationStatus.completed) ||
          (status == AnimationStatus.dismissed)) {
        SmartlookHelperController.changeTransitioningState(false);
        animation?.removeStatusListener(listener);
      }
    };

    if (animation?.status == AnimationStatus.completed) {
      // when animation is already over on startup
      SmartlookHelperController.changeTransitioningState(false);
    } else {
      animation?.addStatusListener(listener);
    }
  }
}
