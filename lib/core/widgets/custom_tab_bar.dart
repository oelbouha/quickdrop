import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userPhotoUrl;
  final TabController tabController;
  final List tabs;
  final String? title;
  final bool expanded;
  const CustomAppBar({
    super.key,
    required this.userPhotoUrl,
    required this.tabController,
    this.expanded = true,
    required this.tabs,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),  
      curve: Curves.easeOut,
      height: expanded ? kToolbarHeight + 80 : 100,
      child: AppBar(
      backgroundColor: AppColors.appBarBackground,
       title:   expanded
          ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: const TextStyle(
                  color: AppColors.appBarText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
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
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.blue,
                      backgroundImage: userPhotoUrl.startsWith("http")
                          ? NetworkImage(userPhotoUrl)
                          : AssetImage(userPhotoUrl) as ImageProvider,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          )
        : null,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          height: 48,
          color: AppColors.background,
          child: TabBar(
            controller: tabController,
            labelColor: AppColors.tabTextActive,
            unselectedLabelColor: AppColors.tabTextInactive,
            indicator: const UnderlineGradientIndicator(
            gradient: LinearGradient(
              colors: [AppColors.blueStart, AppColors.purpleStart],
            ),
            strokeWidth: 3,
          ),
            tabAlignment: TabAlignment.fill,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: AppColors.lessImportant,
            dividerHeight: 0.4,
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
    ));
  }

  @override
  Size get preferredSize => Size.fromHeight(expanded ? kToolbarHeight + 48: 48);
}



class UnderlineGradientIndicator extends Decoration {
  final Gradient gradient;
  final double strokeWidth;

  const UnderlineGradientIndicator({
    required this.gradient,
    this.strokeWidth = 3,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(gradient, strokeWidth, BorderRadius.circular(8));
  }
}
class _UnderlinePainter extends BoxPainter {
  final Gradient gradient;
  final double strokeWidth;
  final BorderRadius borderRadius;

  _UnderlinePainter(this.gradient, this.strokeWidth, this.borderRadius);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final width = config.size?.width ?? 0;
    final height = config.size?.height ?? 0;
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy + height - strokeWidth,
      width,
      strokeWidth,
    );

    final rrect = borderRadius.toRRect(rect);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, paint);
  }
}





