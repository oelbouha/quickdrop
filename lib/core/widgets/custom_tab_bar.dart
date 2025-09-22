import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/build_header_icon.dart';
import 'package:quickdrop_app/theme/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List tabs;
  final String? title;

  const CustomAppBar({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.blue,
      centerTitle: true, 
      title: Text(
        title ?? "",
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        buildHeaderIcon(
          icon: "assets/icon/help.svg",
          onTap: () => print("Help tapped"),
          color: AppColors.white
        ),
        const SizedBox(width: 8),
        const NotificationIcon(
          color: AppColors.white
        ),
        const SizedBox(width: 12),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          color: AppColors.appBarBackground, // Different background for tabs
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.blue700,
            unselectedLabelColor: AppColors.tabTextInactive,
            indicatorColor: AppColors.blue700,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: AppColors.lessImportant,
            dividerHeight: 0.4,
            isScrollable: tabs.length > 3,
            tabAlignment:
                tabs.length > 3 ? TabAlignment.start : TabAlignment.fill,
            padding: tabs.length > 3
                ? const EdgeInsets.symmetric(horizontal: 16)
                : null,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 48);
}
