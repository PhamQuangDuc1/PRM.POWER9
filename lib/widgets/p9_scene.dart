import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/p9_theme.dart';

/// Local artwork is decorative: product text supplies all meaningful content.
abstract final class P9Scenes {
  static const login = 'assets/illustrations/login-office-v1.png';
  static const today = 'assets/illustrations/today-morning-v1.png';
  static const movement = 'assets/illustrations/movement-walk-v1.png';
  static const food = 'assets/illustrations/nutrition-lunch-v1.png';
  static const relax = 'assets/illustrations/relax-breathe-v2.png';
  static const connection = 'assets/illustrations/connection-colleagues-v2.png';
  static const workspace = 'assets/illustrations/workspace-ergonomic-v2.png';
  static const recovery = 'assets/illustrations/recovery-evening-v1.png';

  static String forActivity(Activity activity) => switch (activity.id) {
    'eat-lunch' => food,
    'stress-break' => relax,
    'space-desk' || 'posture-check' => workspace,
    'sleep-prepare' => recovery,
    'purpose-note' => today,
    'balance-review' => login,
    'social-walk' => movement,
    _ => activity.groupId == 'social' ? connection : movement,
  };
}

class P9SceneBanner extends StatelessWidget {
  const P9SceneBanner({
    super.key,
    required this.asset,
    this.height = 152,
    this.alignment = Alignment.topCenter,
  });

  final String asset;
  final double height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(P9Size.cardRadius),
      child: Image.asset(
        asset,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        alignment: alignment,
        cacheWidth: 960,
        excludeFromSemantics: true,
      ),
    ),
  );
}

class P9InstructionStep extends StatelessWidget {
  const P9InstructionStep({
    super.key,
    required this.number,
    required this.text,
  });
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: P9Space.md),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: P9Colors.card,
        borderRadius: BorderRadius.circular(P9Size.controlRadius),
        border: Border.all(color: P9Colors.surfaceContainer),
      ),
      child: Padding(
        padding: const EdgeInsets.all(P9Space.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: P9Colors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: P9Colors.primaryStrong,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: P9Space.md),
            Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    ),
  );
}
