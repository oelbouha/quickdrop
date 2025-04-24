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
      child:  Padding(
              padding: const EdgeInsets.all(AppTheme.historyCardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10,),
                  _buildBody(),
                   const SizedBox(height: 10,),
                  _buildFooter(),
                ],
        )));
  }



  Widget _buildHeader() {
    return Row(
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
          IconButton(
            icon: const CustomIcon(
                iconPath: "assets/icon/trash-bin.svg",
                size: 20,
                color: AppColors.error),
            onPressed: widget.onPressed,
          )
      ],
    );
  }

 Widget _buildBody() {
    return Column(
      children: [
          Destination(from: widget.item.from, to: widget.item.to),
        const SizedBox(
          height: 3,
        ),
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
          height: 3,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return  Row(
      children: [
         Text('Price:  ${widget.item.price}dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        const Spacer(),
          _buildButtons(),
          ],
    );
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
      label: const Text("Leave review", style: TextStyle(color: AppColors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.cardButtonRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }

}
