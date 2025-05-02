import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
export 'package:quickdrop_app/core/widgets/user_profile.dart';

class CompletedItemCard extends StatefulWidget {
 final TransportItem item;
  final Map<String, dynamic> user;
  final VoidCallback onPressed;

  const CompletedItemCard({super.key, 
      required this.item, 
      required this.user,
      required this.onPressed
    });

  @override
  CompletedItemCardState createState() => CompletedItemCardState();
}

class CompletedItemCardState extends State<CompletedItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.2,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBody(),
                  const SizedBox(height: 10,),
                  
                  _buildFooter(),
                ],
        ));
  }



  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(10),
        decoration:  BoxDecoration(
          color: AppColors.courierInfoBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
      children: [
        UserProfileCard(
          header: widget.user['displayName'],
          onPressed: () => print("user profile  Clicked"),
          subHeader: widget.item is Shipment ?  "Package Carrier" : "Package owner", 
          photoUrl: widget.user['photoUrl'],
          headerFontSize: 14,
          subHeaderFontSize: 10,
          avatarSize: 18,
        ),
          const Spacer(),
         Container(
            padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 3,
                bottom: 3
            ),
            decoration:  BoxDecoration(
                color: AppColors.completedstatusBackground,
                borderRadius: BorderRadius.circular(30),
            ),
            child: const  Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/check-circle.svg",
                  size: 10,
                  color: AppColors.completedStatusText,
                ),
                SizedBox(width: 5,),
                Text("Completed", style: TextStyle(fontSize: 8, color: AppColors.completedStatusText), )
              ]
          )),
      ],
    ));
  }

 Widget _buildBody() {
    return Padding(
       padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 4,
      ),
      child: Column(
      children: [
          Row(children: [
          Destination(from: widget.item.from, to: widget.item.to),
         
        ]),
        buildIconWithText(
          iconPath: "calendar.svg", 
          text: 'Departure time ${widget.item.date}'
        ),
        const SizedBox(
          height: 3,
        ),
        buildIconWithText(
          iconPath: "weight.svg", 
          text: 'Weight ${widget.item.weight} kg'
        ),
        const SizedBox(
          height: 8,
        ),
        _buildUserCard()
      ],
    ));
  }

  Widget _buildFooter() {
    return  Container(
       padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 4,
        bottom: 4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardFooterBackground,
        borderRadius:  BorderRadius.only(
          bottomRight: Radius.circular(AppTheme.cardRadius),
          bottomLeft: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      child: Row(
      children: [
         Text('${widget.item.price}dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const Spacer(),
          _buildButtons(),
          ],
    ));
  }

  Widget _buildButtons() {
    return  ElevatedButton.icon(
      onPressed: () {
        print("review  clicked!");
      },
      icon: const CustomIcon(
        iconPath: "assets/icon/star.svg",
        size: 20,
        color: Colors.white,
      ),
      label: const Text("Rate trip", style: TextStyle(color: AppColors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rateBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
    );
  }

}
