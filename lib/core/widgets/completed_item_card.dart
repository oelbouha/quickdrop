import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';
export 'package:quickdrop_app/core/widgets/user_profile.dart';
export 'package:quickdrop_app/core/widgets/review.dart';

class CompletedItemCard extends StatefulWidget {
 final TransportItem item;
  final UserData user;
  final VoidCallback onPressed;
  final VoidCallback onViewPressed;


  const CompletedItemCard({super.key, 
      required this.item, 
      required this.user,
      required this.onPressed
      ,required this.onViewPressed
    });

  @override
  CompletedItemCardState createState() => CompletedItemCardState();
}

class CompletedItemCardState extends State<CompletedItemCard> {
  final reviewController = TextEditingController();

  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        return ReviewDialog(
          recieverUser: widget.user,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onViewPressed, child: Container(
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
        )));
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
        UserProfileWithRating(
          user: widget.user,
          header: widget.user.displayName ?? 'Guest',
          avatarSize: 34,
          headerFontSize: 10,
          subHeaderFontSize: 8,
          onPressed: () =>
              {context.push('/profile/statistics?userId=${widget.user.uid}')},
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Destination(from: widget.item.from, to: widget.item.to),
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
      onPressed: _submitReview,
      icon: const CustomIcon(
        iconPath: "assets/icon/star.svg",
        size: 20,
        color: Colors.white,
      ),
      label: const Text("Rate trip", style: TextStyle(color: AppColors.white, fontSize: 12),),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.rateBackground,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        elevation: 0,
      ),
    );
  }

}
