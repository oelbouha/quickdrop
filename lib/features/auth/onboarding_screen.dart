

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   void _onIntroEnd(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('onboarding_seen', true);
//     context.pushReplacementNamed('login');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/images/back1.png'), 
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: IntroductionScreen(
//         globalBackgroundColor: AppColors.background,
//         pages: [
//           PageViewModel(
//             title: "Welcome to QuickDrop",
//             body:
//                 "Send and receive packages easily with our peer-to-peer delivery system — faster, cheaper, and more personal.",
//             decoration: const PageDecoration(
//               imageFlex: 0,
//               bodyFlex: 2,
//               bodyAlignment: Alignment.center,
//               bodyPadding:
//                   EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//               titleTextStyle: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               bodyTextStyle: TextStyle(fontSize: 16),
//             ),
//           ),
//           PageViewModel(
//             title: "Community-Powered Delivery",
//             body:
//                 "Connect with trusted travelers going your way. They carry your packages safely while earning extra income.",
//             decoration: const PageDecoration(
//               imageFlex: 0,
//               bodyFlex: 2,
//               bodyAlignment: Alignment.center,
//               bodyPadding:
//                   EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//               titleTextStyle: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               bodyTextStyle: TextStyle(fontSize: 16),
//             ),
//           ),
//           PageViewModel(
//             title: "Earn While You Travel",
//             body:
//                 "Deliver packages along your route and get paid instantly. QuickDrop turns every trip into an opportunity.",
//             decoration: const PageDecoration(
//               imageFlex: 0,
//               bodyFlex: 2,
//               bodyAlignment: Alignment.center,
//               bodyPadding:
//                   EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//               titleTextStyle: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//               bodyTextStyle: TextStyle(fontSize: 16),
//             ),
//             footer: Padding(
//               padding: const EdgeInsets.all(24),
//               child: LoginButton(
//                 hintText: "Get Started",
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 textColor: Theme.of(context).colorScheme.onPrimary,
//                 onPressed: () {
//                   context.pushNamed('login');
//                 },
//                 isLoading: false,
//                 radius: 60,
//               ),
//             ),
//           ),
//         ],
//         onDone: () => _onIntroEnd(context),
//         showSkipButton: true,
//         skip: const Text("Skip"),
//         next: const Icon(Icons.arrow_forward),
//         done:
//             const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
//         dotsDecorator: const DotsDecorator(
//           size: Size(10.0, 10.0),
//           activeSize: Size(22.0, 10.0),
//           activeShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           ),
//         ),
//       ),
//     );
//   }
// }
