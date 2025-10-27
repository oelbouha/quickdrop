import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/icon_text_button.dart';
import 'package:quickdrop_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> _getPages(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    return [
      OnboardingPage(
        title: t.onboarding_1_title,
        body: t.onboarding_1_body,
        icon: Icons.inventory_2_outlined,
        gradientColors: [Color(0xFF6750A4), Color(0xFF8B7AB8)],
      ),
      OnboardingPage(
        title: t.onboarding_2_title,
        body: t.onboarding_2_body,
        icon: Icons.people_outline,
        gradientColors: [Color(0xFF625B71), Color(0xFF7D7085)],
      ),
      OnboardingPage(
        title: t.onboarding_3_title,
        body: t.onboarding_3_body,
        icon: Icons.location_on_outlined,
        gradientColors: [Color(0xFF7D5260), Color(0xFF9A6B77)],
      ),
      OnboardingPage(
        title: t.onboarding_4_title,
        body: t.onboarding_4_body,
        icon: Icons.attach_money,
        gradientColors: [Color(0xFF6750A4), Color(0xFF7D5260)],
      ),
    ];
  }

  void _onIntroEnd() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (mounted) {
      context.pushNamed('login');
    }
  }

  void _onSkip() {
    _onIntroEnd();
  }

  void _onNext(int pagesLength) {
    if (_currentPage < pagesLength - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onIntroEnd();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = AppLocalizations.of(context)!;
    final pages = _getPages(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.secondary.withOpacity(0.2),
              colorScheme.tertiary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(pages[index], pages.length, colorScheme, t);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  t.onboarding_terms_text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onBackground.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int pagesLength, ColorScheme colorScheme, AppLocalizations t) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card Container
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Section
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: page.gradientColors,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(48.0),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 96,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        page.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page.body,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pagesLength,
                          (index) => GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == index ? 32 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? colorScheme.primary
                                    : colorScheme.primary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: IconTextButton(
                            hint: _currentPage == pagesLength - 1
                                ? t.onboarding_get_started
                                : t.onboarding_next,
                            iconPath: _currentPage < pagesLength - 1
                                ? "assets/icon/arrow-right.svg"
                                : "assets/icon/check.svg",
                            onPressed: () => _onNext(pagesLength),
                            isLoading: false,
                          )),
                           
                        if (_currentPage < pagesLength - 1) ...[
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () => {
                              _onSkip(),
                            },
                            child: Text(
                              t.onboarding_skip,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ]
                        ],
                      ), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String body;
  final IconData icon;
  final List<Color> gradientColors;

  OnboardingPage({
    required this.title,
    required this.body,
    required this.icon,
    required this.gradientColors,
  });
}