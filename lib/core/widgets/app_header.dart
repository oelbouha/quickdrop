import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:go_router/go_router.dart';

Widget buildHomePageHeader(
    BuildContext context, String subHeader, bool isHome) {
  if (isHome) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 0, top: 0),
        child: _buildTopHeader(context));
  }
  return Padding(
      padding: const EdgeInsets.only(left: 10, right: 0, top: 0),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopHeader(context),
            const SizedBox(height: 10),
            Text(
              subHeader,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]));
}

Widget _buildTopHeader(BuildContext context) {
  String? photoUrl =
      Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
  if (photoUrl == null || photoUrl.isEmpty) {
    photoUrl = "assets/images/profile.png"; // Default image
  }
  ImageProvider imageProvider;
  if (photoUrl.startsWith('http')) {
    imageProvider = NetworkImage(photoUrl);
  } else {
    imageProvider = AssetImage(photoUrl);
  }
  return Row(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          context.push("/profile");
        },
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.blue,
          backgroundImage: imageProvider,
        ),
      ),
      const Spacer(),
      // TextButton.icon(
      //   onPressed: () {
      //     context.push("/help");
      //   },
      //   icon: const CustomIcon(
      //       iconPath: "assets/icon/help.svg", size: 20, color: AppColors.white),
      //   label: const Text(
      //     "Help",
      //     style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
      //   ),
      //   style: TextButton.styleFrom(
      //     backgroundColor: AppColors.warning,
      //     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     elevation: 0.0,
      //   ),
      // ),
      // const SizedBox(
      //   width: 10,
      // ),
      IconButton(
        icon: const CustomIcon(
            iconPath: "assets/icon/notification.svg",
            size: 24,
            color: AppColors.white),
        onPressed: () {
          context.push("/notification");
        },
      )
    ],
  );
}
