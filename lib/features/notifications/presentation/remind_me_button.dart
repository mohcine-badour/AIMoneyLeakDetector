import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../domain/reminder_planner.dart';
import '../notifications_providers.dart';

class RemindMeRow extends ConsumerStatefulWidget {
  const RemindMeRow({required this.eventDate, super.key});

  final DateTime eventDate;

  @override
  ConsumerState<RemindMeRow> createState() => _RemindMeRowState();
}

class _RemindMeRowState extends ConsumerState<RemindMeRow> {
  var _pending = false;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: const Key('remind-me'),
        onTap: _pending ? null : _remind,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: tokens.bgMuted,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  AppIcons.bellRinging,
                  size: 18,
                  color: tokens.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.remindMe,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.remindMeHint,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: tokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_pending)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: tokens.textMuted,
                  ),
                )
              else
                Icon(AppIcons.chevronRight, size: 16, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _remind() async {
    HapticFeedback.selectionClick();
    setState(() => _pending = true);
    final allowed = await ref.read(remindersEnabledProvider.notifier).enable();
    if (!mounted) {
      return;
    }
    setState(() => _pending = false);
    if (!allowed) {
      _snack(AppStrings.reminderPermissionDenied);
      return;
    }
    final upcoming = ReminderPlanner.hasUpcoming(
      eventDate: widget.eventDate,
      now: ref.read(appNowProvider),
    );
    _snack(
      upcoming ? AppStrings.reminderArmed : AppStrings.reminderNothingUpcoming,
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
