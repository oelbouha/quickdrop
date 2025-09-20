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
    return GestureDetector(
      onTap: widget.onViewPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:   Column(
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
                  ),
                  const SizedBox(height: 16),
                  _buildBody(),
              ])),
            _buildFooter(),
          ],
      )));
  }



  Widget _buildBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: BuildInfoShip(
                icon: Icons.calendar_today,
                label: 'Pickup Date',
                value: '${widget.item.date}',
                accentColor: const Color(0xFFDC2626), // Red color for date
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BuildInfoShip(
                icon:  Icons.inventory_2_outlined,
                label: 'Weight',
                 value: '${widget.item.weight}kg',
                accentColor: const Color(0xFF2563EB), // Blue color for weight
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 14,
                  color: const Color(0xFF6B7280),
                ),
                const SizedBox(width: 6),
                Text(
                  'Est. Pickup: ${widget.item.date}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              '${widget.item.price}dh',
              style: const TextStyle(
                fontSize: 20,
                color: AppColors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF9CA3AF),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.visibility_outlined,
              label: 'View',
              onPressed: widget.onViewPressed,
              color: const Color(0xFF2563EB),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.edit_outlined,
              label: 'Edit',
              onPressed: widget.onEditPressed,
              color: const Color(0xFF059669),
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: BuildShipmentCardActionButton(
              icon: Icons.delete_outline,
              label: 'Delete',
              onPressed: widget.onPressed,
              color: const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }


}