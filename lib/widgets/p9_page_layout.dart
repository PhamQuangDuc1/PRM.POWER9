import 'package:flutter/material.dart';

class P9PageBody extends StatelessWidget {
  const P9PageBody({super.key, required this.child});

  final Widget child;
  static const maxWidth = 640.0;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    ),
  );
}

class P9PageScaffold extends StatelessWidget {
  const P9PageScaffold({super.key, required this.appBar, required this.body});

  final AppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: appBar,
    body: P9PageBody(child: body),
  );
}
