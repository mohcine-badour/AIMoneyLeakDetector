import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/ad_placement.dart';
import '../domain/ad_service.dart';

class LocalAdService implements AdService {
  const LocalAdService();

  @override
  Widget banner({required AdPlacement placement, VoidCallback? onUpgrade}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('ad-banner-${placement.name}'),
        onTap: onUpgrade,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(
                AppStrings.adLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  AppStrings.adRemoveHint,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
