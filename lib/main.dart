import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'injection/injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const ColTradeApp());
}

class ColTradeApp extends StatelessWidget {
  const ColTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ColTrade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}

