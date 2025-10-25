
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/report_user_dialog.dart';
import 'package:quickdrop_app/core/widgets/user_profile_avatar.dart';

class OngoingItemCard extends StatefulWidget {
  final TransportItem item;
  final UserData user;
  final VoidCallback onViewPressed;

  const OngoingItemCard({
    super.key,
    required this.item,
    required this.user,
    required this.onViewPressed,
  });

  @override
  OngoingItemCardState createState() => OngoingItemCardState();
}

class OngoingItemCardState extends State<OngoingItemCard> {
  void _submitReview() {
    showDialog(
      context: context,
      builder: (context) {
        return ReviewUserDialog(
          recieverUser: widget.user,
        );
      },
    );
  }

  void _submitReport() {
    showDialog(
      context: context,
      builder: (context) {
        return ReportUserDialog(
          recieverUser: widget.user,
        );
      },
    );
  }

  void _contactCourier() async {
    context.push(
      "/convo-screen",
      extra: {
        'uid': widget.user.uid,
        'displayName': widget.user.displayName ?? "Unknown user",
        'photoUrl': widget.user.photoUrl ?? AppTheme.defaultProfileImage,
      },
    );
  }

  void markShipmentAsDelivered(String id) async {
    try {
      _submitReview();
      if (widget.item is Shipment) {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedShipments");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingShipments");
      }
      if (widget.item is Trip) {
        await Provider.of<TripProvider>(context, listen: false)
            .updateStatus(id, DeliveryStatus.completed);
        Provider.of<StatisticsProvider>(context, listen: false)
            .incrementField(widget.item.userId, "completedTrips");
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(widget.item.userId, "ongoingTrips");
      }
    } catch (e) {
      if (mounted) {
          AppUtils.showDialog(
              context, AppLocalizations.of(context)!.update_failed, AppColors.error);
        }
    }
  }

  void _showDeliveryConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.succes.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const CustomIcon(
                  iconPath: "assets/icon/check-circle.svg",
                  size: 20,
                  color: AppColors.succes,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.mark_as_delivered_title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.confirm_delivery_message,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.succes.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.succes.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.item.from} → ${widget.item.to}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppLocalizations.of(context)!.courier_label}: ${widget.user.displayName ?? AppLocalizations.of(context)!.guest_user}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${AppLocalizations.of(context)!.price_label_dh}: ${widget.item.price} DH',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.delivery_complete_rating_info,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.succes,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                AppLocalizations.of(context)!.not_yet,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                markShipmentAsDelivered(widget.item.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.succes,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.mark_delivered_button,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }


 
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onViewPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: AppColors.cardBackground.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  BuildHeader(
                      from: widget.item.from,
                      to: widget.item.to,
                      id: widget.item.id,
                      price: widget.item.price),
                  const SizedBox(height: 16),
                  _buildBody(),
                  const SizedBox(height: 16),
                  _buildCourierCard(),
                ])),
            _buildFooter(),
          ],
        ),
      ),
    );
  }




  Widget _buildBody() {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildInfoColumn(
            label: t.date,
            value: '${widget.item.date}',
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: const Color(0xFFE5E7EB),
        ),
        Expanded(
          child: _buildInfoColumn(
            label: t.weight,
            value: '${widget.item.weight}kg',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCourierCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.courierInfoBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomIcon(
                iconPath: "assets/icon/user.svg",
                size: 14,
                color: AppColors.blue600,
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context)!.your_courier_label,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: UserProfileWithRating(
                  user: widget.user,
                  header: widget.user.displayName ?? 'Guest',
                  avatarSize: 36,
                  headerFontSize: 12,
                  subHeaderFontSize: 9,
                  onPressed: () => {
                    context
                        .push('/profile/statistics?userId=${widget.user.uid}')
                  },
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _contactCourier,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.contactBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.blue.withOpacity(0.2),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomIcon(
                          iconPath: "assets/icon/chat-round-line.svg",
                          size: 16,
                          color: AppColors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.chat_button,
                          style: const TextStyle(
                            color: AppColors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: BuildPrimaryButton(
                  onPressed: _showDeliveryConfirmation,
                  label: AppLocalizations.of(context)!.delivered_button,
                  color: AppColors.succes,
                  icon: "assets/icon/circle-check.svg"),
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              icon: "assets/icon/eye.svg",
              onPressed: widget.onViewPressed,
              iconColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              icon: "assets/icon/report.svg",
              onPressed: _submitReport,
              iconColor: Theme.of(context).colorScheme.error,
            ),
          ],
        ));
  }
}
