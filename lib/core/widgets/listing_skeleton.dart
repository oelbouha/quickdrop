import 'package:quickdrop_app/core/utils/imports.dart';

class ListingSkeleton extends StatelessWidget {
  const ListingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: AppColors.white,
          body: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  _buildListingsSkeleton(),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildListingsSkeleton() {
    return Column(
      children: List.generate(3, (index) {
        return Column(
          children: [
            _buildShimmer(
              child: Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  color: AppColors.skeletonColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmer(
                        child: Container(
                          width: 120,
                          height: 50,
                         decoration: BoxDecoration(
                          color: AppColors.skeletonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        ),
                      ),
                    const SizedBox(height: 8),
                     _buildShimmer(
                        child: Container(
                          width: 60,
                          height: 30,
                         decoration: BoxDecoration(
                          color: AppColors.skeletonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        ),
                      ),
                    const Spacer(),
                    _buildShimmer(
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.skeletonColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                    )
                  ],
                 
              ),
            ),)),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

  Widget _buildShimmer({required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      child: _ShimmerWidget(child: child),
    );
  }
}

class _ShimmerWidget extends StatefulWidget {
  final Widget child;

  const _ShimmerWidget({required this.child});

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                (_animation.value - 1.0).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1.0).clamp(0.0, 1.0),
              ],
              transform: GradientRotation(0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
