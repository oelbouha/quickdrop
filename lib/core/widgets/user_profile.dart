import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/utils/appUtils.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class UserProfileCard extends StatelessWidget {
  final String header;
  final String photoUrl;
  final VoidCallback onPressed;
  final String subHeader;
  final double headerFontSize;
  final double subHeaderFontSize;
  final double avatarSize;
  final Color subHeaderColor;
  final Color headerColor;

  const UserProfileCard({
    super.key,
    required this.header,
    required this.onPressed,
    required this.photoUrl,
    this.subHeader = "",
    required this.headerFontSize,
     this.subHeaderFontSize = 12,
    required this.avatarSize,
    this.subHeaderColor = AppColors.lessImportant,
    this.headerColor = AppColors.headingText,
  });

  @override
  Widget build(BuildContext context) {
    // ImageProvider imageProvider;
    // if (photoUrl.startsWith('http')) {
    //   imageProvider = NetworkImage(photoUrl);
    // } else {
    //   imageProvider = AssetImage(photoUrl);
    // }
    
    return Row(
      children: [
      GestureDetector (
         onTap: onPressed,
          child:Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.blue.withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Image.network(
                    photoUrl ?? AppTheme.defaultProfileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.blue.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.blue,
                          size: 26,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header.length > 30 ? 
                "${header.substring(0, 30)}..." :
                header,
              style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.bold,
                  color: headerColor
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            if (subHeader != "") Text(
              subHeader.length > 30
                  ? "${subHeader.substring(0, 30)}..."
                  : subHeader,
              style: TextStyle(
                  color: subHeaderColor, fontSize: subHeaderFontSize, fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}




  // Widget _buildUserProfile() {
  //   return Row(
  //     children: [
  //       Stack(
  //         children: [
  //           Container(
  //             width: 48,
  //             height: 48,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(24),
  //               border: Border.all(
  //                 color: AppColors.blue.withOpacity(0.3),
  //                 width: 3,
  //               ),
  //             ),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(21),
  //               child: Image.network(
  //                 widget.userData.photoUrl ?? AppTheme.defaultProfileImage,
  //                 fit: BoxFit.cover,
  //                 errorBuilder: (context, error, stackTrace) {
  //                   return Container(
  //                     color: AppColors.blue.withOpacity(0.1),
  //                     child: const Icon(
  //                       Icons.person,
  //                       color: AppColors.blue,
  //                       size: 26,
  //                     ),
  //                   );
  //                 },
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(width: 12),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               header,
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: AppColors.headingText,
  //               ),
  //             ),
  //             const SizedBox(height: 2),
  //             Row(
  //               children: [
  //                 const Icon(
  //                   Icons.star,
  //                   color: Colors.amber,
  //                   size: 16,
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   "${4.5}",
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: AppColors.headingText,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   "•",
  //                   style: TextStyle(
  //                     color: Colors.grey[400],
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 const Icon(
  //                   Icons.trending_up,
  //                   color: Colors.green,
  //                   size: 14,
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   "${0} deliveries",
  //                   style: const TextStyle(
  //                     fontSize: 13,
  //                     color: AppColors.lessImportant,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

