import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/core/widgets/user_profile.dart';
import 'package:quickdrop_app/core/widgets/numberField.dart';
import 'package:quickdrop_app/core/widgets/login_button.dart';
import 'package:quickdrop_app/core/widgets/textFeild.dart';
import 'package:quickdrop_app/features/models/shipment_modeel.dart';
import 'package:quickdrop_app/features/models/user_model.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/utils/appUtils.dart';


class ShipmentCard extends StatefulWidget {
  final Shipment shipment;
  final Map<String, dynamic> userData;

  final VoidCallback onPressed;
  
  const ShipmentCard({
    super.key, 
    required this.shipment, 
    required this.userData,
    required this.onPressed,
    });

  @override
  ShipmentCardState createState() => ShipmentCardState();
}

class ShipmentCardState extends State<ShipmentCard> {
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
      // padding: const EdgeInsets.all(AppTheme.cardPadding),
      height: AppTheme.imageHeight,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 29, 28, 28).withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _listingImage(),
          _buildListingDetails(),
        ],
      ),
    ));
  }

  Widget _buildRequesBody() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: noteController,
            hintText: "Note",
            backgroundColor: AppColors.cardBackground,
            maxLines: 2,
          ),
          const SizedBox(
            height: 20,
          ),
          NumberField(
            controller: priceController,
            hintText: "Start price",
            backgroundColor: AppColors.cardBackground,
          ),
          const SizedBox(
            height: 20,
          ),
          LoginButton(
              isLoading: false,
              hintText: "Send request",
              onPressed: () => {print("list package")}),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return UserProfileCard(
      header: widget.userData['displayName'] ?? "Unknown user",
      onPressed: () => print("user profile  Clicked"),
      photoUrl: widget.userData['photoUrl'],
      headerFontSize: 12,
      subHeaderFontSize: 8,
      avatarSize: 14,
    );
  }

  Widget _buildPrice() {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.end, 
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("From ",
            style:  TextStyle(color: AppColors.lessImportant, fontSize: 12)),
        Text('${widget.shipment.price}dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

 Widget _buildDestination() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFromDestination(),
        const SizedBox(
          width: 5,
        ),
         const CustomIcon(
            iconPath: "assets/icon/arrow-up-right.svg",
            size: 14,
            color: AppColors.lessImportant),
        // Spacer(),
         const SizedBox(
          width: 5,
        ),
        _buildToDestination(),
        
      ],
    );
  }

  Widget _buildFromDestination() {
    return Row(
      children: [
           const Icon(
                  Icons.circle,
                  size: 12,
                  color: AppColors.blue,
                ),
        const SizedBox(width: 5,),
        Text(
            truncateText(widget.shipment.from),
            style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.bold
                )
          ),
      ],
    );
  }


  Widget _buildToDestination() {
    return Row(
      children: [
         const Icon(
                  Icons.circle,
                  size: 12,
                  color: AppColors.succes,
                ),
        const SizedBox(
          width: 5,
        ),
        Text(truncateText(widget.shipment.to),
            style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildListingDetails() {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(),
                const SizedBox(height: AppTheme.cardGap),
                _buildDestination(),
                const SizedBox(height: AppTheme.cardGap),
                ItemDetail(
                  iconPath: "assets/icon/calendar.svg",
                  title: "Delivery by: ",
                  value: '${widget.shipment.date}',
                ),
                const SizedBox(height: AppTheme.cardGap),
                ItemDetail(
                  iconPath: "assets/icon/weight.svg",
                  title: "Weight ",
                  value: widget.shipment.weight + " kg",
                ),
                Spacer(),
                _buildPrice(),
              ],
            )));
  }

  Widget _listingImage() {
    return Row(children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.cardRadius),
          bottomLeft: Radius.circular(AppTheme.cardRadius),
        ),
        child: Image.asset(
          'assets/images/box.jpg',
          width: AppTheme.imageWidth,
          height: AppTheme.imageHeight,
          fit: BoxFit.cover,
        ),
      ),
    ]);
  }
}
