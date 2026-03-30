import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../injection/injection.dart';
import '../bloc/assistant_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/agent.dart';
import 'agent_profile_screen.dart';
import 'agent_contact_screen.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  String _activeFilter = 'Ubicación';

  final _filters = ['Ubicación', 'Especialidad', 'Rating'];

  final _agents = [
    Agent(
      initials: 'JP',
      name: 'Juan Pérez',
      agency: 'Agencia Aduanera Valia',
      experience: '12 años',
      city: 'Bogotá, CO',
      rating: 4.9,
      specialties: const ['Importación', 'DIAN', 'Agrícola'],
      verified: true,
      bio:
          'Juan es un experto en importaciones y normativas DIAN enfocado en el sector agrícola.',
    ),
    Agent(
      initials: 'MC',
      name: 'María Contreras',
      agency: 'GlobalTrade Colombia',
      experience: '8 años',
      city: 'Medellín, CO',
      rating: 4.7,
      specialties: const ['Exportación', 'TLC', 'Textiles'],
      verified: true,
      bio:
          'María lidera operaciones de exportación bajo TLCs con un foco especializado en el sector textil de Antioquia.',
    ),
    Agent(
      initials: 'CR',
      name: 'Carlos Ruiz',
      agency: 'Aduanas Express S.A.',
      experience: '15 años',
      city: 'Cartagena, CO',
      rating: 4.8,
      specialties: const ['Logística', 'Puertos', 'Industriales'],
      verified: false,
    ),
    Agent(
      initials: 'AL',
      name: 'Ana López',
      agency: 'Comercio Global LTDA',
      experience: '6 años',
      city: 'Cali, CO',
      rating: 4.5,
      specialties: const ['Importación', 'Retail', 'INVIMA'],
      verified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        title: 'Agentes',
        dark: true,
        actions: [
          IconButton(
            icon: const NotificationBell(color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Search
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Buscar agentes de aduana...',
                hintStyle: AppTextStyles.bodySmall,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textLabel),
                filled: true,
                fillColor: AppColors.surfaceGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Filter row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final active = f == _activeFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primaryDarkNavy
                            : AppColors.surfaceGray,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: active
                              ? AppColors.primaryDarkNavy
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            f == 'Ubicación'
                                ? Icons.location_on_outlined
                                : f == 'Especialidad'
                                    ? Icons.people_outline_rounded
                                    : Icons.star_outline_rounded,
                            size: 14,
                            color:
                                active ? Colors.white : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(f,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: active
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              )),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down_rounded,
                              size: 16,
                              color: active
                                  ? Colors.white60
                                  : AppColors.textLabel),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _agents.length,
              itemBuilder: (_, i) => _buildAgentCard(_agents[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(Agent agent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(agent.initials,
                          style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                  if (agent.verified)
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.infoBlue,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                              BorderSide(color: Colors.white, width: 1.5)),
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 11),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(agent.name, style: AppTextStyles.cardTitle),
                    Text(agent.agency, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: AppColors.textLabel),
                        const SizedBox(width: 3),
                        Text('${agent.experience} de experiencia',
                            style: AppTextStyles.caption),
                        const SizedBox(width: 6),
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: AppColors.textLabel),
                        const SizedBox(width: 3),
                        Text(agent.city, style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 2),
                  Text(agent.rating.toString(),
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Specialties
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: agent.specialties.map((s) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(s, style: AppTextStyles.caption),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 6,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (_) => sl<AssistantBloc>(),
                                child: AgentContactScreen(agent: agent),
                              ))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarkNavy,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: Text('Contactar',
                      style: AppTextStyles.buttonCTA.copyWith(fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AgentProfileScreen(agent: agent))),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDarkNavy,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text('Perfil',
                      style: AppTextStyles.buttonCTA.copyWith(
                          fontSize: 14, color: AppColors.textPrimary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
