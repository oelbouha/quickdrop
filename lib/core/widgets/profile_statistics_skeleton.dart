import 'package:quickdrop_app/core/utils/imports.dart';

class ProfileStatisticsSkeleon extends StatelessWidget {
  const ProfileStatisticsSkeleon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
     
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildUserStatusSkeleton(),
            const SizedBox(height: AppTheme.cardPadding),
            _buildContentSkeleton(),
          ],
        ),
      ),
    );
  }

 

  Widget _buildUserStatusSkeleton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: AppTheme.cardPadding,
        right: AppTheme.cardPadding,
        top: AppTheme.cardPadding * 2,
        bottom: AppTheme.cardPadding * 2,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blueStart, AppColors.purpleEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileImageSkeleton(),
          const SizedBox(height: 15),
          _buildUserInfoSkeleton(),
          const SizedBox(height: 16),
          _buildStatsPreviewSkeleton(),
        ],
      ),
    );
  }

  Widget _buildProfileImageSkeleton() {
    return _buildShimmer(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(55),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSkeleton() {
    return Column(
      children: [
        _buildShimmer(
          child: Container(
            width: 150,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildShimmer(
          child: Container(
            width: 120,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsPreviewSkeleton() {
    return _buildShimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSkeleton() {
    return Column(
      children: [
        _buildStatisticsSectionSkeleton(),
        const SizedBox(height: 32),
        _buildReviewsSectionSkeleton(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatisticsSectionSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeaderSkeleton(),
          const SizedBox(height: 16),
          _buildStatsRowSkeleton(),
          const SizedBox(height: 32),
          _buildSectionHeaderSkeleton(),
          const SizedBox(height: 16),
          _buildStatsRowSkeleton(),
        ],
      ),
    );
  }

  Widget _buildSectionHeaderSkeleton() {
    return Row(
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
        const SizedBox(width: 12),
        _buildShimmer(
          child: Container(
            width: 140,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.skeletonColor,
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRowSkeleton() {
    return Row(
      children: [
        Expanded(child: _buildStatCardSkeleton()),
        Expanded(child: _buildStatCardSkeleton()),
        Expanded(child: _buildStatCardSkeleton()),
      ],
    );
  }

  Widget _buildStatCardSkeleton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
          const SizedBox(height: 8),
          _buildShimmer(
            child: Container(
              width: 30,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.skeletonColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _buildShimmer(
            child: Container(
              width: 60,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.skeletonColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSectionSkeleton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              const SizedBox(width: 12),
              _buildShimmer(
                child: Container(
                  width: 80,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.skeletonColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildShimmer(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.skeletonColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 20,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.skeletonColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewsListSkeleton(),
        ],
      ),
    );
  }

  Widget _buildReviewsListSkeleton() {
    return Column(
      children: List.generate(3, (index) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildReviewCardSkeleton(),
            ),
            const SizedBox(height: 12),
          ],
        );
      }),
    );
  }

  Widget _buildReviewCardSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmer(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.skeletonColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
                    const SizedBox(height: 4),
                    _buildShimmer(
                      child: Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.skeletonColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildShimmer(
                child: Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.skeletonColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildShimmer(
            child: Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.skeletonColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
          // const SizedBox(height: 8),
          // _buildShimmer(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.7,
          //     height: 14,
          //     decoration: BoxDecoration(
          //       color: AppColors.skeletonColor,
          //       borderRadius: BorderRadius.circular(7),
          //     ),
          //   ),
          // ),
        ],
      ),
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