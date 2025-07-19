

import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

  Widget buildEmptyState(IconData icon,String message, ) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.blue700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child:  Icon(
                icon,
                size: 54,
                color: AppColors.blue700.withValues(alpha: 0.6),
              ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
