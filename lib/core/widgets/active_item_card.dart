import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/actionButton.dart';
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
    required this.onEditPressed,
    required this.onViewPressed,
  });

  @override
  State<ActiveItemCard> createState() => _ActiveItemCardState();
}

class _ActiveItemCardState extends State<ActiveItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column( 
                children: [
                  BuildHeader(
                      from: widget.item.from,
                      to: widget.item.to,
                      id: widget.item.id,
                      price: widget.item.price
                    ),
                  const SizedBox(height: 16),
                  _buildBody(),
              ])),
            _buildFooter(),
          ],
        ));
  }

  Widget _buildBody() {
    return Row(
      children: [
        
        Expanded(
          child: _buildInfoColumn(
            label: 'Date',
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
            label: 'Weight',
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

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: 12
      ),
      child:  Row(
      children: [
        Expanded(
           child: BuildPrimaryButton(
            onPressed: widget.onViewPressed,
            label: 'View details',
            color: Theme.of(context).colorScheme.secondary,
            icon: "assets/icon/eye.svg"
          ),
        ),
        const SizedBox(width: 12),
        SecondaryButton(
          icon: "assets/icon/edit.svg",
          onPressed: widget.onEditPressed,
          iconColor: Theme.of(context).colorScheme.primary,
          
        ),
        const SizedBox(width: 12),
        SecondaryButton(
          icon: "assets/icon/trash-bin.svg",
          onPressed: widget.onPressed,
          iconColor: AppColors.error,
        ),
      ],
    ));
  }



  Widget _buildSecondaryButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 16,
            color: const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

