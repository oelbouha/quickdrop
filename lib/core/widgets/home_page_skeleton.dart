import 'package:quickdrop_app/core/utils/imports.dart';

class HomePageSkeleton extends StatefulWidget {
  const HomePageSkeleton({super.key});

  @override
  State<HomePageSkeleton> createState() => _HomePageSkeletonState();
}

class _HomePageSkeletonState extends State<HomePageSkeleton>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    
    // Initialize entrance animation controller
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered slide and fade animations for different sections
    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5), // Start from below
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _entranceController,
        curve: Interval(
          index * 0.15, // Stagger the animations
          0.8 + (index * 0.05),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _entranceController,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOut,
        ),
      ));
    });

    // Start the entrance animation
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

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
              // AppBar doesn't animate from below
              _buildAppBarSkeleton(),
              const SizedBox(height: 24),
              // Hero section - index 0
              _buildAnimatedSection(
                child: _buildHeroSkeleton(),
                animationIndex: 0,
              ),
              const SizedBox(height: 32),
              // Value props - index 1
              _buildAnimatedSection(
                child: _buildValuePropsSkeleton(),
                animationIndex: 1,
              ),
              const SizedBox(height: 32),
              // Services - index 2
              _buildAnimatedSection(
                child: _buildServicesSkeleton(),
                animationIndex: 2,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({
    required Widget child,
    required int animationIndex,
  }) {
    return SlideTransition(
      position: _slideAnimations[animationIndex],
      child: FadeTransition(
        opacity: _fadeAnimations[animationIndex],
        child: child,
      ),
    );
  }

  Widget _buildAppBarSkeleton() {
    return Row(
      children: [
        Row(
          children: [
            _buildEnhancedShimmer(
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
                _buildEnhancedShimmer(
                  child: Container(
                    width: 120,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.skeletonColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _buildEnhancedShimmer(
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
            _buildEnhancedShimmer(
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
            _buildEnhancedShimmer(
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
    return _buildEnhancedShimmer(
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.skeletonColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildValuePropsSkeleton() {
    return Row(
      children: [
        Expanded(
          child: _buildEnhancedShimmer(
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
          child: _buildEnhancedShimmer(
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
        _buildEnhancedShimmer(
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
        _buildEnhancedShimmer(
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
        _buildEnhancedShimmer(
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

  Widget _buildEnhancedShimmer({required Widget child}) {
    return _EnhancedShimmerWidget(child: child);
  }
}

class _EnhancedShimmerWidget extends StatefulWidget {
  final Widget child;

  const _EnhancedShimmerWidget({required this.child});

  @override
  State<_EnhancedShimmerWidget> createState() => _EnhancedShimmerWidgetState();
}

class _EnhancedShimmerWidgetState extends State<_EnhancedShimmerWidget>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _colorController;
  late Animation<double> _shimmerAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Shimmer animation (moving gradient effect)
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Color animation (background color transition like YouTube)
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: const Color(0xFFE8E8E8),
          end: const Color(0xFFF0F0F0),
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: const Color(0xFFF0F0F0),
          end: const Color(0xFFF8F8F8),
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: const Color(0xFFF8F8F8),
          end: const Color(0xFFE8E8E8),
        ),
      ),
    ]).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    // Start both animations
    _shimmerController.repeat();
    _colorController.repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shimmerAnimation, _colorAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: _extractBorderRadius(),
          ),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.3),
                  Colors.white.withOpacity(0.0),
                ],
                stops: [
                  (_shimmerAnimation.value - 1.0).clamp(0.0, 1.0),
                  (_shimmerAnimation.value - 0.5).clamp(0.0, 1.0),
                  _shimmerAnimation.value.clamp(0.0, 1.0),
                  (_shimmerAnimation.value + 0.5).clamp(0.0, 1.0),
                  (_shimmerAnimation.value + 1.0).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            child: widget.child,
          ),
        );
      },
    );
  }

  BorderRadius? _extractBorderRadius() {
    final decoration = widget.child is Container
        ? (widget.child as Container).decoration
        : null;
    
    if (decoration is BoxDecoration) {
      return decoration.borderRadius as BorderRadius?;
    }
    return null;
  }
}