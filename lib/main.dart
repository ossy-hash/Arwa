import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state_provider.dart';
import 'utils/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/english_screen.dart';
import 'screens/math_screen.dart';
import 'screens/arabic_screen.dart';
import 'screens/games_screen.dart';
import 'screens/rewards_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArwaApp());
}

class ArwaApp extends StatelessWidget {
  const ArwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: MaterialApp(
        title: 'ARWA - Kids Learning',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/english': (context) => const EnglishScreen(),
          '/math': (context) => const MathScreen(),
          '/arabic': (context) => const ArabicScreen(),
          '/games': (context) => const GamesScreen(),
          '/rewards': (context) => const RewardsScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
