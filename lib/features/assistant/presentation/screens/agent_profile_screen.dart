import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../injection/injection.dart';
import '../bloc/assistant_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent.dart';
import 'agent_contact_screen.dart';

class AgentProfileScreen extends StatelessWidget {
  final Agent agent;

  const AgentProfileScreen({super.key, required this.agent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Agent Header info
                  Center(
                    child: Column(
                      children: [
                         Text(agent.name, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                         const SizedBox(height: 4),
                         Text(agent.agency, style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textSecondary)),
                         const SizedBox(height: 16),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             _MetricStat(icon: Icons.star_rounded, label: agent.rating.toString(), sublabel: 'Rating'),
                             Container(width: 1, height: 30, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 16)),
                             _MetricStat(icon: Icons.access_time_rounded, label: agent.experience, sublabel: 'Exp.'),
                             Container(width: 1, height: 30, color: AppColors.border, margin: const EdgeInsets.symmetric(horizontal: 16)),
                             _MetricStat(icon: Icons.comment_rounded, label: agent.reviewsCount.toString(), sublabel: 'Reseñas'),
                           ],
                         )
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // About Section
                  Text('Sobre mí', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),
                  Text(agent.bio, style: AppTextStyles.bodyRegular.copyWith(height: 1.5, color: AppColors.textBody)),
                  
                  const SizedBox(height: 24),

                  // Specialties
                  Text('Especialidades', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: agent.specialties.map((s) => Chip(
                      label: Text(s),
                      backgroundColor: AppColors.surfaceGray,
                      labelStyle: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.border)),
                    )).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Certifications
                  Text('Certificaciones', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),
                  ...agent.certifications.map((cert) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_rounded, color: AppColors.successGreen, size: 20),
                        const SizedBox(width: 12),
                        Text(cert, style: AppTextStyles.bodyRegular),
                      ],
                    ),
                  )),

                  const SizedBox(height: 100), // padding for bottom bar
                ],
              ),
            ),
          )
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))
          ]
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BlocProvider(
                create: (_) => sl<AssistantBloc>(),
                child: AgentContactScreen(agent: agent),
              ))),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDarkNavy,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Contactar Agente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primaryDarkNavy,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            Container(decoration: const BoxDecoration(color: AppColors.primaryDarkNavy)),
            // Avatar
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Hero(
                  tag: 'agent_avatar_${agent.name}',
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Center(
                          child: Text(agent.initials,
                              style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDarkNavy)),
                        ),
                      ),
                      if (agent.verified)
                        Positioned(
                          right: -4,
                          bottom: 4,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: AppColors.infoBlue,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2)),
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _MetricStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _MetricStat({required this.icon, required this.label, required this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.yellowAmber, size: 18),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          ],
        ),
        const SizedBox(height: 2),
        Text(sublabel, style: AppTextStyles.caption.copyWith(color: AppColors.textLabel)),
      ],
    );
  }
}
