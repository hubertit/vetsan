import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../../../home/presentation/providers/tab_index_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String _appVersionText = 'Version ${AppConfig.appVersion}';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _checkAuthState();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersionText = 'Version ${info.version} (${info.buildNumber})';
      });
    } catch (_) {
      // Ignore version fetch errors; keep UI clean
    }
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(
      Duration(milliseconds: AppConfig.splashDuration),
    );
    if (!mounted) return;
    
    // Check if user is already logged in
    final isLoggedIn = await ref.read(authProvider.notifier).isUserLoggedIn();
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      // User is logged in, set default tab to home and go to home screen
      ref.read(tabIndexProvider.notifier).state = 0; // Home tab
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // User is not logged in, go to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
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
            'assets/images/splash.jpg',
            fit: BoxFit.cover,
          ),
          // Gradient overlay at bottom for text visibility
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // Loader in the center
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
                  '© ${DateTime.now().year} VetSan',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.surfaceColor,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  _appVersionText,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.surfaceColor,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
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