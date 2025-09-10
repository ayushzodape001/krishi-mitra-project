// splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart'; // We import main.dart to use its theme colors and navigate to ChatScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;

  late AnimationController _textController;
  late Animation<double> _textOpacityAnimation;
  
  @override
  void initState() {
    super.initState();

    // --- Animation Setup ---
    
    // Controller for the leaf icon
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Physics-based "elastic" curve for a satisfying bounce
    _iconScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut)
    );
    _iconRotationAnimation = Tween<double>(begin: -0.5, end: 0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutQuart)
    );
    
    // Controller for the text fade-in
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn)
    );

    // --- Staggered Animation Logic ---
    _iconController.forward(); // Start the icon animation
    
    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward(); // When icon is done, start the text fade-in
      }
    });
    
    // --- Navigation to Chat Screen ---
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(_createFadeRoute());
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  // --- Custom Page Transition for a smooth fade ---
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const ChatScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Leaf Icon
            RotationTransition(
              turns: _iconRotationAnimation,
              child: ScaleTransition(
                scale: _iconScaleAnimation,
                child: const Icon(
                  Icons.energy_savings_leaf, 
                  color: kPrimaryGreen,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Animated Text
            FadeTransition(
              opacity: _textOpacityAnimation,
              child: Text(
                'Krishi Mitra',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
