import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabs;
  final List<String>icons;

  const CustomTabBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabs,
    this.icons = const ['pending.svg', 'ongoing.svg', 'completed.svg']
  }) : super(key: key);

  // Define the preferred size
  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(40),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  for(int i = 0; i < tabs.length; ++i) ...[
                    if (i > 0) const SizedBox( width: 8, ),
                    _buildTabButton(tabs[i], icons[i], i),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Custom button widget
  Widget _buildTabButton(String text, String icon, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        onTabSelected(index);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.tabBarRadius),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.tabBarBorderColor,
            width: 1,
          ),
        ),
        
        child: Row(
          children: [
            // if (text == "Packages")
            //  CustomIcon(
            //   iconPath: "assets/icon/package.svg", 
            //   size: 30 , 
            //   color: isSelected ? AppColors.headingText : AppColors.blue,
            // ),
            // if (text == "Trips") 
             CustomIcon(
              iconPath: 'assets/icon/${icon}', 
              size: 30 , 
              color: isSelected ? AppColors.headingText : AppColors.blue,
            ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
        ),
          ])
      ),
    );
  }
}
