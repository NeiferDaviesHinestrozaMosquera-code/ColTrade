import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

// ─── Data Models ──────────────────────────────────────────────────────────────
enum _TicketStatus { abierto, enProceso, cerrado }

class _Ticket {
  final String id;
  final String title;
  final String description;
  final String date;
  final _TicketStatus status;
  final List<_TicketEvent> timeline;

  const _Ticket({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.timeline,
  });
}

class _TicketEvent {
  final String title;
  final String? subtitle;
  final String? timestamp;
  final TimelineStatus timelineStatus;

  const _TicketEvent({
    required this.title,
    this.subtitle,
    this.timestamp,
    required this.timelineStatus,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final List<_Ticket> _tickets = [
    const _Ticket(
      id: 'TKT-0042',
      title: 'Error en cálculo de aranceles',
      description:
          'El módulo de calculadora no aplica el TLC Colombia-UE correctamente para la partida 0901.21.',
      date: '18 Mar 2026',
      status: _TicketStatus.enProceso,
      timeline: [
        _TicketEvent(
            title: 'Ticket creado',
            timestamp: '18 Mar · 10:05',
            timelineStatus: TimelineStatus.completed),
        _TicketEvent(
            title: 'Asignado a soporte técnico',
            subtitle: 'Agente: María Torres',
            timestamp: '18 Mar · 11:30',
            timelineStatus: TimelineStatus.completed),
        _TicketEvent(
            title: 'En revisión por el equipo técnico',
            subtitle: 'Estimado: 24 hrs',
            timelineStatus: TimelineStatus.active),
        _TicketEvent(
            title: 'Resolución y cierre',
            timelineStatus: TimelineStatus.pending),
      ],
    ),
    const _Ticket(
      id: 'TKT-0039',
      title: 'Incorporar agente de Buenaventura',
      description:
          'Solicitud para agregar al agente aduanal Logística Pacífico S.A.S. al directorio.',
      date: '15 Mar 2026',
      status: _TicketStatus.abierto,
      timeline: [
        _TicketEvent(
            title: 'Ticket creado',
            timestamp: '15 Mar · 09:00',
            timelineStatus: TimelineStatus.completed),
        _TicketEvent(
            title: 'En cola de revisión',
            timelineStatus: TimelineStatus.active),
        _TicketEvent(
            title: 'Validación de datos del agente',
            timelineStatus: TimelineStatus.pending),
        _TicketEvent(
            title: 'Publicación en el directorio',
            timelineStatus: TimelineStatus.pending),
      ],
    ),
    const _Ticket(
      id: 'TKT-0031',
      title: 'Generación de certificado de origen',
      description:
          'El sistema generó un certificado con la fecha de embarque incorrecta.',
      date: '02 Mar 2026',
      status: _TicketStatus.cerrado,
      timeline: [
        _TicketEvent(
            title: 'Ticket creado',
            timestamp: '02 Mar · 14:00',
            timelineStatus: TimelineStatus.completed),
        _TicketEvent(
            title: 'Investigado y resuelto',
            timestamp: '03 Mar · 09:15',
            timelineStatus: TimelineStatus.completed),
        _TicketEvent(
            title: 'Ticket cerrado',
            timestamp: '03 Mar · 10:00',
            timelineStatus: TimelineStatus.completed),
      ],
    ),
  ];

  BadgeStatus _badgeFor(_TicketStatus s) => switch (s) {
        _TicketStatus.abierto => BadgeStatus.informativo,
        _TicketStatus.enProceso => BadgeStatus.enProceso,
        _TicketStatus.cerrado => BadgeStatus.completado,
      };

  String _labelFor(_TicketStatus s) => switch (s) {
        _TicketStatus.abierto => 'ABIERTO',
        _TicketStatus.enProceso => 'EN PROCESO',
        _TicketStatus.cerrado => 'CERRADO',
      };

  int get _countAbiertos =>
      _tickets.where((t) => t.status == _TicketStatus.abierto).length;
  int get _countEnProceso =>
      _tickets.where((t) => t.status == _TicketStatus.enProceso).length;
  int get _countCerrados =>
      _tickets.where((t) => t.status == _TicketStatus.cerrado).length;

  void _showDetail(BuildContext context, _Ticket ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TicketDetailSheet(
          ticket: ticket, badgeFor: _badgeFor, labelFor: _labelFor),
    );
  }

  void _showCreateTicket() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _CreateTicketSheet(
          onSubmit: (title, description) {
            setState(() {
              final newId = 'TKT-00${_tickets.length + 43}';
              final now = DateTime.now();
              const months = [
                'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
              ];
              final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
              final timeStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} · ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

              _tickets.insert(
                0,
                _Ticket(
                  id: newId,
                  title: title,
                  description: description,
                  date: dateStr,
                  status: _TicketStatus.abierto,
                  timeline: [
                    _TicketEvent(
                      title: 'Ticket creado',
                      timestamp: timeStr,
                      timelineStatus: TimelineStatus.completed,
                    ),
                    const _TicketEvent(
                      title: 'En cola de asignación',
                      timelineStatus: TimelineStatus.active,
                    ),
                  ],
                ),
              );
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(title: 'Mis Tickets', dark: true),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [
              // ── KPI Row ─────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                      child: _kpiMini(
                          'Abiertos', '$_countAbiertos', AppColors.infoBlue)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _kpiMini('En proceso', '$_countEnProceso',
                          AppColors.accentOrange)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _kpiMini('Cerrados', '$_countCerrados',
                          AppColors.successGreen)),
                ],
              ),
              const SizedBox(height: 20),
              Text('HISTORIAL', style: AppTextStyles.labelUppercase),
              const SizedBox(height: 10),

              // ── Ticket List ─────────────────────────────────────────────
              for (final ticket in _tickets) ...[
                _buildTicketCard(context, ticket),
                const SizedBox(height: 12),
              ],
            ],
          ),

          // ── CTA pinned bottom ──────────────────────────────────────────
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: CTAButton(
              label: '➕  Nuevo Ticket',
              onTap: _showCreateTicket,
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpiMini(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, _Ticket ticket) {
    return GestureDetector(
      onTap: () => _showDetail(context, ticket),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppDecorations.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusBadge(
                  status: _badgeFor(ticket.status),
                  customLabel: _labelFor(ticket.status),
                ),
                const Spacer(),
                Text(ticket.id,
                    style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 10),
            Text(ticket.title,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
            const SizedBox(height: 4),
            Text(ticket.description,
                style: AppTextStyles.caption,
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.textLabel),
                const SizedBox(width: 4),
                Text(ticket.date, style: AppTextStyles.caption),
                const Spacer(),
                Text('Ver detalle →',
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────
class _TicketDetailSheet extends StatelessWidget {
  final _Ticket ticket;
  final BadgeStatus Function(_TicketStatus) badgeFor;
  final String Function(_TicketStatus) labelFor;

  const _TicketDetailSheet({
    required this.ticket,
    required this.badgeFor,
    required this.labelFor,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // Header
                  Row(
                    children: [
                      StatusBadge(
                        status: badgeFor(ticket.status),
                        customLabel: labelFor(ticket.status),
                      ),
                      const Spacer(),
                      Text(ticket.id,
                          style: AppTextStyles.bodySmall
                              .copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(ticket.title,
                      style: GoogleFonts.inter(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(ticket.description, style: AppTextStyles.bodySmall),

                  const SizedBox(height: 24),
                  Text('HISTORIAL DEL TICKET',
                      style: AppTextStyles.labelUppercase),
                  const SizedBox(height: 16),

                  // Timeline
                  ...ticket.timeline.asMap().entries.map((e) => TimelineStep(
                        status: e.value.timelineStatus,
                        title: e.value.title,
                        subtitle: e.value.subtitle,
                        timestamp: e.value.timestamp,
                        isLast: e.key == ticket.timeline.length - 1,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Create Ticket Form Sheet ────────────────────────────────────────────────
class _CreateTicketSheet extends StatefulWidget {
  final void Function(String title, String description) onSubmit;

  const _CreateTicketSheet({required this.onSubmit});

  @override
  State<_CreateTicketSheet> createState() => _CreateTicketSheetState();
}

class _CreateTicketSheetState extends State<_CreateTicketSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Nuevo Ticket de Soporte',
                style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text('Describe tu problema o solicitud con el mayor detalle posible.',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 24),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Asunto',
                hintText: 'Ej. Error en cálculos aduaneros',
                prefixIcon: Icon(Icons.title, color: AppColors.textSecondary),
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              onSaved: (v) => _title = v ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Explica el escenario, ejemplos, qué intentabas hacer...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.trim().length < 10
                  ? 'Mínimo 10 caracteres'
                  : null,
              onSaved: (v) => _description = v ?? '',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDarkNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(_title, _description);
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('✅ Ticket creado exitosamente'),
                        backgroundColor: AppColors.successGreen,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                child: Text('Enviar Ticket',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
