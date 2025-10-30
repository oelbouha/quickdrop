import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/theme/colors.dart';

class BuildHeader extends StatelessWidget {
  final String from;
  final String to;
  final String? id;
  final String price;

  const BuildHeader({
    super.key,
    required this.from,
    required this.to,
    required this.price,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final t = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   '#{id }',
              //   style: const TextStyle(
              //     fontSize: 12,
              //     color: Color(0xFF3B82F6), // Blue-500
              //     fontWeight: FontWeight.w700,
              //     letterSpacing: 0.5,
              //   ),
              // ),
              // const SizedBox(height: 8),
              Row(
                children: [
              const Icon(
                    Icons.circle,
                    size: 10,
                    color: AppColors.blue, // Gray-500
                  ),
                  const SizedBox(width: 8),
              Text(
                from,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111827), // Gray-900
                ),
              ),]),
              const SizedBox(height: 4),
              Row(
                children: [
                   CustomIcon(
                    iconPath: isArabic ? "assets/icon/arrow-bottom-left.svg" : "assets/icon/arrow-bottom-right.svg",
                    size: 16,
                    color: Color(0xFF6B7280), // Gray-500
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      to,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              price,
             style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
            ),
             Text(
              t.dirham,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
            ),
          ],
        ),
      ],
    );
  }
}
