import 'package:flutter/material.dart';

import '../theme/p9_theme.dart';
import 'p9_button.dart';
import 'p9_logo.dart';

class P9StatusScreen extends StatelessWidget {
  const P9StatusScreen({super.key, required this.message, this.retry});
  final String message;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(P9Space.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: P9Size.contentMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const P9Logo(),
                const SizedBox(height: P9Space.xl),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: P9Space.xl),
                if (retry case final callback?)
                  P9Button(label: 'Thử lại', onPressed: callback)
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
