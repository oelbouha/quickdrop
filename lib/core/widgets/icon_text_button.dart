import 'package:quickdrop_app/core/utils/imports.dart';

class IconTextButton extends StatefulWidget {
   final VoidCallback onPressed;
   final bool isLoading;
   final String iconPath;
   final String hint;
   final double radius;
   final String loadingText;
   final Color backgroundColor;

  const IconTextButton({
    Key? key, 
    required this.onPressed,
    required this.isLoading,
    required this.iconPath,
    required this.hint,
    this.radius = 8,
    this.backgroundColor = AppColors.blue,
    this.loadingText = 'Saving...',
    }) : super(key: key);

  @override
  State<IconTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  


  Widget buildIconTextButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.blue700.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(widget.radius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.loadingText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                   CustomIcon(iconPath: widget.iconPath, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.hint,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return buildIconTextButton();
  }
}
