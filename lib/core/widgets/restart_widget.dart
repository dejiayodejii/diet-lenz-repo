import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A small helper widget that can rebuild the top-level [ProviderScope]
/// by changing its key. Calling [RestartWidget.restartApp(context)] will
/// recreate the [ProviderScope], effectively resetting all providers.
class RestartWidget extends StatefulWidget {
  final Widget child;
  final List<Override> overrides;

  const RestartWidget(
      {Key? key, required this.child, this.overrides = const []})
      : super(key: key);

  /// Call this to recreate the [ProviderScope] and reset providers.
  static void restartApp(BuildContext context) {
    final _RestartWidgetState? state =
        context.findAncestorStateOfType<_RestartWidgetState>();
    state?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _providerScopeKey = UniqueKey();

  void _restart() {
    setState(() {
      _providerScopeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: _providerScopeKey,
      overrides: widget.overrides,
      child: widget.child,
    );
  }
}
