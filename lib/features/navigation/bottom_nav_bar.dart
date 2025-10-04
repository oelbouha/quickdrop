import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';



class BottomNavScreen extends StatelessWidget {
  final Widget child;
  
  const BottomNavScreen({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   systemNavigationBarColor:
    //       AppColors.cardBackground, // Set the color of the phone's bottom bar
    //   systemNavigationBarIconBrightness:
    //       Brightness.light, // Make icons light if the background is dark
    // ));
    return Scaffold(
        body: child,
        bottomNavigationBar: Container(
  decoration:  BoxDecoration(
    border: Border(
      top:  BorderSide(
        color: Colors.grey, // Color of the top border
        width: 0.4, // Thickness of the border
      ),
    ),
  ),
  child: Theme(
    data: Theme.of(context).copyWith(
      splashColor: AppColors.cardBackground, // Removes white ripple effect
      highlightColor: AppColors.cardBackground, // Disables highlight animation
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _calculateIndex(context),
      onTap: (index) => _onTap(index, context),
      showSelectedLabels: true,
      selectedItemColor: AppColors.navTextActive,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      backgroundColor: AppColors.white,
      unselectedItemColor: AppColors.navTextInactive,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIconWithBackground(
            iconPath: "assets/icon/search.svg",
            isSelected: _calculateIndex(context) == 0,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: _buildIconWithBackground(
            iconPath: "assets/icon/route.svg",
            isSelected: _calculateIndex(context) == 1,
          ),
          label: 'Trip',
        ),
        BottomNavigationBarItem(
          icon: _buildIconWithBackground(
            iconPath: "assets/icon/package.svg",
            isSelected: _calculateIndex(context) == 2,
          ),
          label: 'Shipment',
        ),
        BottomNavigationBarItem(
          icon: _buildIconWithBackground(
            iconPath: "assets/icon/mail-alt.svg",
            isSelected: _calculateIndex(context) == 3,
          ),
          label: 'Requests',
        ),
        BottomNavigationBarItem(
          icon: _buildIconWithBackground(
            iconPath: "assets/icon/chat-round.svg",
            isSelected: _calculateIndex(context) == 4,
          ),
          label: 'Chats',
        ),
      ],
    ),
  ),
        ));
  }

  Widget _buildIconWithBackground({
    required String iconPath,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      width: 48,
      height: 24,
      decoration: BoxDecoration(
          // color: isSelected ? AppColors.blue600.withOpacity(0.4) : null,
          borderRadius: BorderRadius.circular(20)),
      child: CustomIcon(
        iconPath: iconPath,
        size: 20,
        color: isSelected ? AppColors.blue600 : AppColors.navTextInactive,
      ),
    );
  }

  int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri;
    if (location.path == '/trip')  return 1;
    if (location.path == "/shipment") return 2;
    if (location.path == '/requests') return 3;
    if (location.path == '/chats') return 4;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/trip');
        break;
      case 2:
        context.go('/shipment');
        break;
      case 4:
        context.go('/chats');
        break;
      case 3:
        context.go('/requests');
        break;
    }
  }
}
