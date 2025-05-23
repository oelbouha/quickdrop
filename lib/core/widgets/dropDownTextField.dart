import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class DropdownTextField extends StatefulWidget {
  final String? Function(String?)? validator;
  final TextEditingController?
      controller; // Add controller as an optional parameter

  const DropdownTextField({
    super.key,
    required this.validator,
    this.controller, // Optional controller to sync the value
  });

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final List<String> _items = [
    'electronics',
    'glass',
    'water',
    'metal',
    'plastic'
  ]; // Fixed typos
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    // If a controller is provided and has an initial value, set _selectedItem
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      _selectedItem = widget.controller!.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: widget.validator,
      value: _selectedItem,
      decoration: InputDecoration(
        labelText: 'Select a type',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.inputRadius),
          borderSide: const BorderSide(
            color: AppColors.blue,
            width: AppTheme.textFieldBorderWidth,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.inputRadius),
          borderSide: const BorderSide(
            color: AppColors.blue,
            width: AppTheme.textFieldBorderWidth,
          ),
        ),
      ),
      dropdownColor: AppColors.dark,
      items: _items.map((String item) {
        return DropdownMenuItem<String>(
            value: item,
            child: Container(
              // decoration: BoxDecoration(
              //   // color: AppColors.white,
              //   // borderRadius: BorderRadius.circular(30),
              // ),
              child: Text(
                item,
                style: TextStyle(
                  color: _selectedItem == item
                      ? AppColors.blue
                      : Colors.white, // Text color
                ),
              ),
            ));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
          if (widget.controller != null) {
            widget.controller!.text = newValue ?? ''; // Sync with controller
          }
        });
      },
      isExpanded: true,
    );
  }
}
