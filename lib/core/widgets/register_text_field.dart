
import 'package:quickdrop_app/core/utils/imports.dart';

class ImprovedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const ImprovedTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<ImprovedTextField> createState() => _ImprovedTextFieldState();
}

class _ImprovedTextFieldState extends State<ImprovedTextField> {
  bool _isFocused = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.headingText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: (value) {
            if (_hasError) {
              setState(() {
                _hasError = widget.validator?.call(value) != null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused
                  ? AppColors.blue700
                  : _hasError
                      ? AppColors.error
                      : Colors.grey[400],
              size: 20,
            ),
            filled: true,
            fillColor: _isFocused
                ? AppColors.blue700.withOpacity(0.05)
                : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue700, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          // onFocusChange: (focused) {
          //   setState(() {
          //     _isFocused = focused;
          //   });
          // },
        ),
      ],
    );
  }
}