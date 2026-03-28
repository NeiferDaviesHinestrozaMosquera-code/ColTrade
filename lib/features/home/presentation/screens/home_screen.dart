import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/home_bloc.dart';
import '../widgets/dashboard_tab.dart';
import '../widgets/operations_tab.dart';
import '../widgets/tools_tab.dart';
import '../widgets/profile_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final tab = state.selectedTab;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: tab,
            children: const [
              DashboardTab(),
              OperationsTab(),
              ToolsTab(),
              ProfileTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context, tab),
        );
      },
    );
  }

  // ── Bottom Navigation ───────────────────────────────────────────────────

  Widget _buildBottomNav(BuildContext context, int selectedTab) {
    const tabs = [
      (Icons.home_rounded, Icons.home_outlined, 'INICIO'),
      (Icons.anchor_rounded, Icons.anchor_outlined, 'OPERACIONES'),
      (Icons.build_rounded, Icons.build_outlined, 'HERRAMIENTAS'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'PERFIL'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: tabs.asMap().entries.map((e) {
              final active = e.key == selectedTab;
              final (activeIcon, inactiveIcon, label) = e.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      context.read<HomeBloc>().add(ChangeHomeTab(e.key)),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (active)
                        Container(
                          height: 2,
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        )
                      else
                        const SizedBox(height: 2),
                      const SizedBox(height: 6),
                      Icon(
                        active ? activeIcon : inactiveIcon,
                        color: active
                            ? AppColors.accentOrange
                            : AppColors.textLabel,
                        size: 22,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: active
                              ? AppColors.accentOrange
                              : AppColors.textLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
