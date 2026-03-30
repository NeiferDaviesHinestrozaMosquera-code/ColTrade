import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/entities/agent.dart';
import '../bloc/assistant_bloc.dart';
import '../bloc/assistant_event.dart';
import '../bloc/assistant_state.dart';

class AgentContactScreen extends StatefulWidget {
  final Agent agent;

  const AgentContactScreen({super.key, required this.agent});

  @override
  State<AgentContactScreen> createState() => _AgentContactScreenState();
}

class _AgentContactScreenState extends State<AgentContactScreen> {
  final _messageCtrl = TextEditingController();
  String _operationType = 'Consultoría General';

  final _operations = [
    'Consultoría General',
    'Agenciamiento de Importación',
    'Exportación y TLC',
    'Reglas OEA/DIAN',
  ];

  void _sendMessage() {
    if (_messageCtrl.text.trim().isEmpty) return;
    
    context.read<AssistantBloc>().add(ContactAgentEvent(
      agentId: widget.agent.name,
      type: _operationType,
      message: _messageCtrl.text,
    ));
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(
        title: 'Contactar Agente',
        dark: true,
      ),
      body: BlocConsumer<AssistantBloc, AssistantState>(
        listener: (context, state) {
          if (state is AssistantContactSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mensaje enviado exitosamente. El agente te responderá a tu correo corporativo.'),
                backgroundColor: AppColors.successGreen,
              ),
            );
            Navigator.pop(context);
          } else if (state is AssistantError) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text('Error: ${state.message}',
                     style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                 backgroundColor: AppColors.errorRed,
                 behavior: SnackBarBehavior.floating,
               ),
             );
          }
        },
        builder: (context, state) {
          final isSending = state is AssistantContactSending;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Agent Mini Profile
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.blueLight.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'agent_avatar_${widget.agent.name}',
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDarkNavy,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(widget.agent.initials,
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.agent.name, style: AppTextStyles.cardTitle),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text('En línea', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                Text('Tipo de Operación', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _operationType,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                      style: AppTextStyles.bodyRegular.copyWith(color: AppColors.textPrimary),
                      items: _operations.map((op) {
                        return DropdownMenuItem(value: op, child: Text(op));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _operationType = val);
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                Text('Tu Mensaje', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describe tu necesidad. Ej. Hola, necesito realizar una importación desde Miami de 500kg...',
                    hintStyle: AppTextStyles.bodySmall,
                    filled: true,
                    fillColor: AppColors.cardWhite,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primaryDarkNavy, width: 2)),
                  ),
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 12),
                Text(
                  'Esta solicitud se enviará de forma segura a través de los canales de ColTrade. El agente recibirá una alerta y se comunicará contigo vía email.',
                  style: AppTextStyles.caption,
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_messageCtrl.text.trim().isNotEmpty && !isSending) ? _sendMessage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                      disabledBackgroundColor: AppColors.accentOrange.withValues(alpha: 0.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isSending
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Enviar Solicitud', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
