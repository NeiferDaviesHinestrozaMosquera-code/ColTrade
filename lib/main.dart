import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'injection/injection.dart';

import 'features/security/presentation/bloc/auth/auth_bloc.dart';
import 'features/security/presentation/bloc/security_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<SecurityBloc>()),
      ],
      child: MaterialApp.router(
        title: 'ColTrade',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        routerConfig: appRouter,
      ),
    );
  }
}
