import 'package:flutter/material.dart';
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
              Icon(
                    Icons.circle,
                    size: 10,
                    color: AppColors.blue, // Gray-500
                  ),
                  const SizedBox(width: 8),
              Text(
                from,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF111827), // Gray-900
                  fontWeight: FontWeight.w700,
                ),
              ),]),
              const SizedBox(height: 4),
              Row(
                children: [
                  const CustomIcon(
                    iconPath: "assets/icon/map-point.svg",
                    size: 16,
                    color: Color(0xFF6B7280), // Gray-500
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      to,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF6B7280), // Gray-500
                        fontWeight: FontWeight.w600,
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
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF111827), // Gray-900
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'DH',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280), // Gray-500
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
