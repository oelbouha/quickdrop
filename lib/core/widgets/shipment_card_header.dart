import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {
  final String from;
  final String to;
  final String? id;

  const BuildHeader({
    super.key,
    required this.from,
    required this.to,
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
              const Text(
                'Shipment ID',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${id ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${from} → ${to}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFFEF2F2),
        //     borderRadius: BorderRadius.circular(24),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.05),
        //         spreadRadius: 0,
        //         blurRadius: 4,
        //         offset: const Offset(0, 1),
        //       ),
        //     ],
        //   ),
        // child: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Icon(
        //       Icons.schedule,
        //       size: 14,
        //       color: const Color(0xFFDC2626),
        //     ),
        //     const SizedBox(width: 6),
        //     const Text(
        //       'Pending',
        //       style: TextStyle(
        //         fontSize: 12,
        //         color: Color(0xFFDC2626),
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ],
        // ),
        // ),
      ],
    );
  }
}
