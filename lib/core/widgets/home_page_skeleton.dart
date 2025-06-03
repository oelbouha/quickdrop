import 'package:quickdrop_app/core/utils/imports.dart';

class HomePageSkeleton extends StatelessWidget {
  const HomePageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: AppColors.white,
          // appBar: AppBar(
          //   title: _buildAppBarSkeleton(),
          //   backgroundColor: AppColors.white,
          // ),
          body: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: [
              //     Color(0xFFF8FAFC), 
              //     Color(0xFFF1F5F9), 
              //     Color(0xFFE2E8F0), 
              //   ],
              //   stops: [0.0, 0.5, 1.0],
              // ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  _buildAppBarSkeleton(),
                  const SizedBox(height: 24),
                  _buildHeroSkeleton(),
                  const SizedBox(height: 32),
                  _buildValuePropsSkeleton(),
                  const SizedBox(height: 32),
                  _buildServicesSkeleton(),
                  // const SizedBox(height: 24),
                  // _buildListingsHeaderSkeleton(),
                  // const SizedBox(height: 16),
                  // _buildListingsSkeleton(),
                  // const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        );
  }

  Widget _buildAppBarSkeleton() {
    return Row(
      children: [
        Row(
          children: [
            _buildShimmer(
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: AppColors.skeletonColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmer(
                  child: Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.skeletonColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _buildShimmer(
                  child: Container(
                    width: 80,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.skeletonColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            _buildShimmer(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.skeletonColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildShimmer(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.skeletonColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroSkeleton() {
    return _buildShimmer(
      child: Container(
       width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),)
    );
  }

  Widget _buildValuePropsSkeleton() {
    return Row(
      children: [
        Expanded(
          child: _buildShimmer(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.skeletonColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildShimmer(
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.skeletonColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmer(
          child: Container(
            width: 100,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildShimmer(
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildShimmer(
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListingsHeaderSkeleton() {
    return Row(
      children: [
        _buildShimmer(
          child: Container(
            width: 140,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor,
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        const Spacer(),
        _buildShimmer(
          child: Container(
            width: 80,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lessImportant.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
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
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.lessImportant,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
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
