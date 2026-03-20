import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'my_tickets_screen.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const List<(String, String)> _faqs = [
    (
      '¿Cómo creo un nuevo ticket de soporte?',
      'Ve a Perfil → Mis Tickets y toca el botón "➕ Nuevo Ticket" al final de la pantalla. Completa el formulario con el asunto y la descripción de tu consulta.',
    ),
    (
      '¿Cuánto tarda en responderse un ticket?',
      'El tiempo promedio de primera respuesta es de 2 horas hábiles. Tickets de prioridad alta tienen atención dentro de 30 minutos durante horario de servicio.',
    ),
    (
      '¿Cómo puedo actualizar mi plan de suscripción?',
      'Dirígete a Perfil → Empresa → Suscripción. Allí encontrarás las opciones disponibles para cambiar o mejorar tu plan actual.',
    ),
    (
      '¿Qué datos necesito para clasificar mi producto NANDINA?',
      'Necesitas la descripción comercial del producto, país de origen, composición de materiales (si aplica) y el uso final del bien. El asistente IA te guía paso a paso.',
    ),
    (
      '¿Cómo funciona la sincronización con SAP / ERP?',
      'ColTrade ofrece integración vía API REST. Puedes configurar las credenciales en Perfil → API / ERP. Disponible únicamente para el Plan Empresarial.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(title: 'Soporte'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Service Status ───────────────────────────────────────────────
          _buildStatusCard(),
          const SizedBox(height: 20),

          // ── Contact Options ──────────────────────────────────────────────
          Text('CANALES DE ATENCIÓN', style: AppTextStyles.labelUppercase),
          const SizedBox(height: 12),
          _buildContactGrid(context),
          const SizedBox(height: 24),

          // ── FAQ ──────────────────────────────────────────────────────────
          Text('PREGUNTAS FRECUENTES', style: AppTextStyles.labelUppercase),
          const SizedBox(height: 12),
          _buildFaqSection(),
          const SizedBox(height: 24),

          // ── CTA ──────────────────────────────────────────────────────────
          CTAButton(
            label: '🎫  Abrir Ticket',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyTicketsScreen()),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Service Status Card ────────────────────────────────────────────────────
  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F1C3F), Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Centro de Soporte ColTrade',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Servicio activo · Lun–Vie 8am–6pm (COT)',
                        style: AppTextStyles.caption
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Contact Options Grid ──────────────────────────────────────────────────
  Widget _buildContactGrid(BuildContext context) {
    final options = [
      (Icons.chat_bubble_outline_rounded, 'Chat en vivo', AppColors.successGreen),
      (Icons.chat_rounded, 'WhatsApp', const Color(0xFF25D366)),
      (Icons.email_outlined, 'Email', AppColors.infoBlue),
      (Icons.phone_outlined, 'Llamada', AppColors.accentOrange),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 2.2,
      physics: const NeverScrollableScrollPhysics(),
      children: options.map((opt) {
        final (icon, label, color) = opt;
        return GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Abriendo $label…')),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(label,
                    style: AppTextStyles.bodySmall
                        .copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── FAQ ───────────────────────────────────────────────────────────────────
  Widget _buildFaqSection() {
    return Container(
      decoration: AppDecorations.card,
      child: Column(
        children: _faqs.asMap().entries.map((e) {
          final (question, answer) = e.value;
          final isLast = e.key == _faqs.length - 1;
          return Column(
            children: [
              Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  childrenPadding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  iconColor: AppColors.accentOrange,
                  collapsedIconColor: AppColors.textLabel,
                  title: Text(
                    question,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  children: [
                    Text(answer, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
