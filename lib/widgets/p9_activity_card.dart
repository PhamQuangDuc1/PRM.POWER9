import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/p9_theme.dart';
import 'p9_scene.dart';

class P9ActivityCard extends StatelessWidget {
  const P9ActivityCard({
    super.key,
    required this.activity,
    required this.onTap,
  });
  final Activity activity;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    identifier: 'activity-${activity.id}',
    child: Card(
      color: P9Colors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(P9Size.cardRadius),
        side: const BorderSide(color: P9Colors.surfaceContainer),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(P9Size.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(P9Space.lg),
          child: Row(
            children: [
              ExcludeSemantics(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(P9Size.controlRadius),
                  child: Image.asset(
                    P9Scenes.forActivity(activity),
                    width: 64,
                    height: 72,
                    fit: BoxFit.cover,
                    cacheWidth: 192,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(width: P9Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: P9Space.sm),
                    Text(
                      '${activity.groupName} · ${activity.minutes} phút',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: P9Space.sm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    ),
  );
}
