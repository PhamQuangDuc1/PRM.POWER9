import 'package:flutter/material.dart';

import '../theme/p9_theme.dart';

class P9Button extends StatelessWidget {
  const P9Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.loadingLabel = 'Đang xử lý…',
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final String loadingLabel;

  @override
  Widget build(BuildContext context) => Semantics(
    identifier: 'p9-primary-button',
    child: FilledButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox.square(
              dimension: P9Space.xl,
              child: CircularProgressIndicator(
                strokeWidth: P9Size.progressStroke,
              ),
            )
          : icon == null
          ? const SizedBox.shrink()
          : Icon(icon),
      label: Text(loading ? loadingLabel : label),
    ),
  );
}
