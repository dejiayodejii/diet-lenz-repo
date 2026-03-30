import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  static final scaffoldkey = GlobalKey<ScaffoldMessengerState>();
  static BuildContext get context => navigationKey.currentContext!;

  static PageTransitionType type = PageTransitionType.fade;

  static push({required Widget child}) {
    return Navigator.push(context, PageTransition(type: type, child: child));
  }

  static pushReplacement({required Widget child}) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => child));
  }

  static pushAndRemoveUntil({required Widget child}) {
    print('🧭 pushAndRemoveUntil called for ${child.runtimeType}');
    print('🧭 navigationKey.currentContext: ${navigationKey.currentContext}');
    print('🧭 navigationKey.currentState: ${navigationKey.currentState}');
    final result = Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (builder) {
      print('🧭 Building route for ${child.runtimeType}');
      return child;
    }), (_) => false);
    print('🧭 pushAndRemoveUntil dispatched');
    return result;
  }

  static pop() {
    return Navigator.pop(context);
  }
}
