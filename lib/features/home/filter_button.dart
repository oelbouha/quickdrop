import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class FiltterButton extends StatefulWidget {
  const FiltterButton({super.key});

  @override
  FiltterButtonState createState() => FiltterButtonState();
}

class FiltterButtonState extends State<FiltterButton> {
  String _selectedFiltterButton = "All";

  void _onFiltterSelected(String title) {
    setState(() {
      _selectedFiltterButton = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _buildFiltterButton("All"),
      const SizedBox(
        width: 5,
      ),
      _buildFiltterButton("Trips"),
      const SizedBox(
        width: 5,
      ),
      _buildFiltterButton("Shipments")
    ]);
  }

  Widget _buildFiltterButton(String title) {
    bool isSelectedButton = title == _selectedFiltterButton;
    return ElevatedButton(
      onPressed: () {
        _onFiltterSelected(title);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelectedButton ? AppColors.blue: AppColors.background, // Background color
        foregroundColor: isSelectedButton ? AppColors.background: AppColors.headingText, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), 
        side: const BorderSide(color: AppColors.blue, width: 1),// Padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.filtterButtonRadius), // Rounded corners
        ),
        elevation: isSelectedButton? 1: 0,
        // minimumSize: const Size(40, 30),
      ),
      child: Text(title, style: const TextStyle(fontSize: 12),),
    );
  }
}
