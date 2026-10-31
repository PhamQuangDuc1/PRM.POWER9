import 'package:flutter/material.dart';

import '../theme/p9_theme.dart';

class P9Logo extends StatelessWidget {
  const P9Logo({super.key, this.size = P9Size.logo});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    padding: const EdgeInsets.all(P9Space.sm),
    decoration: BoxDecoration(
      color: P9Colors.card,
      borderRadius: BorderRadius.circular(P9Size.cardRadius),
    ),
    child: Image.asset(
      'assets/brand/power9-logo-3d.png',
      fit: BoxFit.contain,
      semanticLabel: 'Logo Power9',
    ),
  );
}
