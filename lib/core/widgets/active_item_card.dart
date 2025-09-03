import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/base_transport.dart';

class ActiveItemCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewPressed,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column( 
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildBody(),
              ])),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${item.id ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280), // gray-500
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.from} → ${item.to}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF111827), // gray-900
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2), // red-50
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Pending',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFEA2A33), // primary red color
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],

    );
  }

  Widget _buildBody() {
    return  Column(
        children: [
          _buildInfoRow(
            icon: Icons.calendar_today,
            text: 'Pickup : ${item.date} ',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.inventory_2_outlined,
            text: 'Weight. ${item.weight}kg',
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
          color: const Color(0xFF9CA3AF), // gray-400
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF374151), // gray-700
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }





  Widget _buildFooter() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB), // gray-200
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              label: 'Edit',
              onPressed: onEditPressed,
              isLeft: true,
            ),
          ),
          Container(
            width: 1,
            height: 48,
            color: const Color(0xFFE5E7EB), // gray-200
          ),
          Expanded(
            child: _buildActionButton(
              label: 'Delete',
              onPressed: onPressed,
              isLeft: false,
            ),
          ),
        ],
      ),
    );

   
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLeft,
  }) {
    return Material(
      color: const Color(0xFFF3F4F6), // gray-100
      borderRadius: BorderRadius.only(
        bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
        bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.only(
          bottomLeft: isLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: !isLeft ? const Radius.circular(12) : Radius.zero,
        ),
        child: Container(
          height: 48,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151), // gray-700
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  
  }

   
}