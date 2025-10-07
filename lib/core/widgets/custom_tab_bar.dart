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
      backgroundColor: Theme.of(context).colorScheme.primary,
      // centerTitle: true,
      title: Text(
        title ?? "",
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500, 
          fontSize: 20, 
        ),
      ),
      actions: [
        // buildHeaderIcon(
        //   icon: "assets/icon/help.svg",
        //   onTap: () => print("Help tapped"),
        //   color: AppColors.white,
        // ),
        // const SizedBox(width: 16),
        const NotificationIcon(color: AppColors.white),
        const SizedBox(width: 16), 
      ],
      bottom: tabs.isNotEmpty
          ? PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: AppColors.white,
                child: TabBar(
                  controller: tabController,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: AppColors.tabTextInactive,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: AppColors.lessImportant,
                  dividerHeight: 0.4,
                  isScrollable: tabs.length > 3,
                  tabAlignment: tabs.length > 3
                      ? TabAlignment.start
                      : TabAlignment.fill,
                  padding: tabs.length > 3
                      ? const EdgeInsets.symmetric(horizontal: 16)
                      : null,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600, 
                    fontSize: 15, 
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500, 
                    fontSize: 15,
                  ),
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (tabs.isNotEmpty ? 48 : 0));
}
