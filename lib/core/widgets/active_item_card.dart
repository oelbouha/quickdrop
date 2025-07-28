import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';

class ActiveItemCard extends StatefulWidget {
  final TransportItem item;
  final VoidCallback onPressed; // Delete callback
  final VoidCallback onEditPressed;
  final VoidCallback onViewPressed;
  
  const ActiveItemCard({
    super.key,
    required this.item,
    required this.onPressed,
    required this.onViewPressed,
    required this.onEditPressed,
  });

  @override
  ActiveListing createState() => ActiveListing();
}

class ActiveListing extends State<ActiveItemCard> with TickerProviderStateMixin {
  

  @override
  void initState() {
    super.initState();
 
  }

 

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
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
                  _buildHeader(),
                  _buildBody(),
                  _buildFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.cardRadius),
          topRight: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.blue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  "Active",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            'ID: #${widget.item.id ?? 'N/A'}',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildBody() {
    return Padding(
        padding: const EdgeInsets.all(16),
      child:  Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          child: Destination(
            from: widget.item.from,
            to: widget.item.to,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: buildPriceCard(price: widget.item.price, label: 'Price')),
      ],
    ));
  }


  Widget _buildDetailRow({
    required String icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomIcon(
            iconPath: icon,
            size: 12,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        _buildActionButtons(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: "Edit",
              color: AppColors.blue600,
              backgroundColor: AppColors.blue600.withOpacity(0.1),
              onTap: widget.onEditPressed,

                iconWidget: const Icon(Icons.edit, size: 14),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              label: "Delete",
              color: Colors.red.shade600,
              backgroundColor: Colors.red.shade50,
              onTap: () => _showDeleteConfirmation(),

                iconWidget: const Icon(Icons.delete_forever, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    String? icon,
    Widget? iconWidget,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 0.5,
            ),
          ),
          child: Center(child:Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            // center the row

            children: [
              if (icon != null)
                CustomIcon(
                  iconPath: icon,
                  size: 14,
                  color: color,
                )
              else if (iconWidget != null)
                IconTheme(
                  data: IconThemeData(color: color),
                  child: iconWidget,
                ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }



  void _showDeleteConfirmation() {
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
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIcon(
                  iconPath: "assets/icon/trash-bin.svg",
                  size: 20,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Item',
                style: TextStyle(
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
                'Are you sure you want to delete this transport item?',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.shade200,
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
                      'Price: ${widget.item.price} DH',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red.shade600,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onPressed(); // Call the delete callback
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}