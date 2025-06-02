import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userPhotoUrl;
  final TabController tabController;
  final List<String> tabs;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.userPhotoUrl,
    required this.tabController,
    required this.tabs,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      title: Text(
        title!,
        style: const TextStyle(
          color: AppColors.appBarText,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      actions: [
        IconButton(
          icon: const CustomIcon(
            iconPath: "assets/icon/notification.svg",
            size: 22,
            color: AppColors.appBarIcons,
          ),
          tooltip: 'notification',
          onPressed: () => context.push("/notification"),
        ),
        GestureDetector(
          onTap: () => context.push("/profile"),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.blue.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.blue,
              backgroundImage: userPhotoUrl.startsWith("http")
                  ? NetworkImage(userPhotoUrl)
                  : AssetImage(userPhotoUrl) as ImageProvider,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.lessImportant.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: TabBar(
              controller: tabController,
              labelColor: AppColors.shipmentText,
              unselectedLabelColor: AppColors.tabTextInactive,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.white,
                    AppColors.white.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: const EdgeInsets.all(4),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 0.3,
              ),
              tabs: tabs.map((tab) => 
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 56);
}