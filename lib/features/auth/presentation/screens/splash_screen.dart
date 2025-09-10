import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import 'lock_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(
      Duration(milliseconds: AppConfig.splashDuration),
    );
    if (!mounted) return;
    
    // Temporarily skip authentication and go directly to lock screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LockScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background cover image
          Image.asset(
            'assets/images/splash_cover.jpg',
            fit: BoxFit.cover,
          ),
          // Loader in the center
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          // Remove the logo image from the splash screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VetSan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.surfaceColor,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Footer with more visible version and copyright
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Column(
              children: [
                Text(
                  'Version ${AppConfig.appVersion}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.surfaceColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '© ${DateTime.now().year} VetSan',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.surfaceColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 