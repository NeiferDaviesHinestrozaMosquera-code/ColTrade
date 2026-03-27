import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/security/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection/injection.dart';

import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/alerts/presentation/bloc/alerts_bloc.dart';
import 'features/checklist/presentation/bloc/checklist_bloc.dart';
import 'features/calculator/presentation/bloc/calculator_bloc.dart';
import 'features/security/presentation/bloc/security_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/academy/presentation/bloc/academy_bloc.dart';
import 'features/assistant/presentation/bloc/assistant_bloc.dart';
import 'features/erp/presentation/bloc/erp_bloc.dart';

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
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<AlertsBloc>()),
        BlocProvider(create: (_) => sl<ChecklistBloc>()),
        BlocProvider(create: (_) => sl<CalculatorBloc>()),
        BlocProvider(create: (_) => sl<SecurityBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<AcademyBloc>()),
        BlocProvider(create: (_) => sl<AssistantBloc>()),
        BlocProvider(create: (_) => sl<ErpBloc>()),
      ],
      child: MaterialApp(
        title: 'ColTrade',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: HomeScreen(),
      ),
    );
  }
}
