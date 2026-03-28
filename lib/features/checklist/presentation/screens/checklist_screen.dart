import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/checklist_bloc.dart';

import '../widgets/checklist_header.dart';
import '../widgets/checklist_progress.dart';
import '../widgets/documents_tab.dart';
import '../widgets/order_tab.dart';
import '../widgets/entities_tab.dart';

class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChecklistBloc()..add(const LoadChecklist()),
      child: const _ChecklistView(),
    );
  }
}

class _ChecklistView extends StatefulWidget {
  const _ChecklistView();

  @override
  State<_ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<_ChecklistView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      context.read<ChecklistBloc>().add(ChangeTab(_tabController.index));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarkNavy,
      appBar: ColTradeAppBar(
        dark: true,
        title: 'Checklist Inteligente',
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          const ChecklistHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: BlocBuilder<ChecklistBloc, ChecklistState>(
                builder: (context, state) {
                  final loaded = state is ChecklistLoaded ? state : null;
                  if (loaded == null) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.accentOrange));
                  }
                  return Column(
                    children: [
                      ChecklistProgress(progress: loaded.progress),
                      _buildTabs(loaded.selectedTab),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            DocumentsTab(docs: loaded.docs),
                            const OrderTab(),
                            const EntitiesTab(),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(int selectedTab) {
    final tabs = ['Documentos', 'Orden de Ejecución', 'Entidades'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: tabs.asMap().entries.map((e) {
          final active = e.key == selectedTab;
          return GestureDetector(
            onTap: () => _tabController.animateTo(e.key),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? AppColors.accentOrange : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                e.value,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.textPrimary : AppColors.textLabel,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
