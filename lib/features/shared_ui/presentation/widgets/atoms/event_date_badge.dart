// lib/features/shared_ui/presentation/widgets/atoms/event_date_badge.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';

class EventDateBadge extends StatelessWidget {
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCompact;

  const EventDateBadge({
    Key? key,
    required this.startDate,
    this.endDate,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = _isSameDay(startDate, now);
    final isTomorrow = _isSameDay(startDate, now.add(const Duration(days: 1)));
    final isPast = startDate.isBefore(now.subtract(const Duration(days: 1)));

    String displayText;
    Color backgroundColor;
    Color textColor;

    if (isToday) {
      displayText = "Aujourd'hui";
      backgroundColor = AppColors.success;
      textColor = Colors.white;
    } else if (isTomorrow) {
      displayText = "Demain";
      backgroundColor = AppColors.warning;
      textColor = Colors.white;
    } else if (isPast) {
      displayText = _formatDate(startDate, isCompact);
      backgroundColor = AppColors.neutral300;
      textColor = AppColors.neutral600;
    } else {
      displayText = _formatDate(startDate, isCompact);
      backgroundColor = AppColors.primary;
      textColor = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXs,
        vertical: AppDimensions.spacingXxs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event,
            size: isCompact ? 12 : 14,
            color: textColor,
          ),
          SizedBox(width: AppDimensions.spacingXxxs),
          Text(
            displayText,
            style: isCompact
                ? AppTypography.caption(isDark: false).copyWith(color: textColor)
                : AppTypography.caption(isDark: false).copyWith(color: textColor),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, bool isCompact) {
    if (isCompact) {
      return DateFormat('dd/MM').format(date);
    }

    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 7) {
      return DateFormat('EEEE dd', 'fr_FR').format(date);
    } else {
      return DateFormat('dd MMM', 'fr_FR').format(date);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}