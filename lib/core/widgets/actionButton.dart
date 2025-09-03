


  import 'package:quickdrop_app/core/utils/imports.dart';

Widget buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLeft,
  }) {
    return Material(
      color: const Color(0xFFF3F4F6), // gray-100
      borderRadius: BorderRadius.only(
        bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
        bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.only(
          bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
        ),
        child: Container(
          height: 48,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151), // gray-700
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }