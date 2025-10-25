import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class TypeSelectorWidget extends StatefulWidget {
  final List<String> types;
  final Function(String) onTypeSelected;
  final String? initialSelection;
  final Color selectedColor;
  final Color unselectedColor;
  final int crossAxisCount;
  final double childAspectRatio;
  final double topSpacing; 

  const TypeSelectorWidget({
    Key? key,
    required this.types,
    required this.onTypeSelected,
    this.initialSelection,
    this.selectedColor = AppColors.blue700, 
    this.unselectedColor = const Color(0xFFE0E0E0),
    this.crossAxisCount = 2,
    this.childAspectRatio = 2.0,
    this.topSpacing = 0,
  }) : super(key: key);

  @override
  State<TypeSelectorWidget> createState() => _TypeSelectorWidgetState();
}

class _TypeSelectorWidgetState extends State<TypeSelectorWidget>
    with TickerProviderStateMixin {
  String? selectedType;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    selectedType = widget.initialSelection;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectType(String type) {
    setState(() {
      selectedType = type;
    });
    widget.onTypeSelected(type);
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.topSpacing), 
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: widget.types.length,
        itemBuilder: (context, index) {
          final type = widget.types[index];
          final isSelected = selectedType == type;

          return AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSelected ? _scaleAnimation.value : 1.0,
                child: GestureDetector(
                  onTap: () => _selectType(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? widget.selectedColor.withValues(alpha: 0.1)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected 
                            ? widget.selectedColor
                            : widget.unselectedColor,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? widget.selectedColor
                                  : Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: widget.selectedColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}