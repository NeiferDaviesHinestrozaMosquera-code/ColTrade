import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

// ─── Model ────────────────────────────────────────────────────────────────────
enum ErpStatus { connected, disconnected, pending }

class ErpSystem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final ErpStatus status;
  final String? lastSync;

  const ErpSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.status,
    this.lastSync,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class ApiErpScreen extends StatefulWidget {
  const ApiErpScreen({super.key});

  @override
  State<ApiErpScreen> createState() => _ApiErpScreenState();
}

class _ApiErpScreenState extends State<ApiErpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _autoSync = true;
  bool _syncOnExport = true;
  bool _syncOnImport = false;
  bool _showApiKey = false;
  bool _syncing = false;

  final _webhookCtrl = TextEditingController(
      text: 'https://api.techcorp.com.co/webhooks/coltrade');

  static const _apiKey = 'ct_live_K9pXm2wQrL5vNjT8hBcA3dFsYeGu1Z4o';

  final List<ErpSystem> _erps = const [
    ErpSystem(
      id: 'sap',
      name: 'SAP Business One',
      description: 'ERP empresarial · v10.0',
      icon: Icons.hub_rounded,
      color: Color(0xFF0070F3),
      status: ErpStatus.connected,
      lastSync: 'Hace 12 min',
    ),
    ErpSystem(
      id: 'siigo',
      name: 'Siigo Cloud',
      description: 'Contabilidad y facturación',
      icon: Icons.receipt_long_rounded,
      color: Color(0xFF7C3AED),
      status: ErpStatus.disconnected,
    ),
    ErpSystem(
      id: 'world',
      name: 'World Office',
      description: 'ERP colombiano',
      icon: Icons.language_rounded,
      color: Color(0xFF059669),
      status: ErpStatus.disconnected,
    ),
    ErpSystem(
      id: 'oracle',
      name: 'Oracle NetSuite',
      description: 'ERP en la nube · Enterprise',
      icon: Icons.cloud_rounded,
      color: Color(0xFFDC2626),
      status: ErpStatus.pending,
      lastSync: 'Configurando...',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _webhookCtrl.dispose();
    super.dispose();
  }

  Future<void> _triggerSync() async {
    setState(() => _syncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _syncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sincronización completada con SAP Business One',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _copyApiKey() {
    Clipboard.setData(const ClipboardData(text: _apiKey));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('API Key copiada al portapapeles',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
        backgroundColor: AppColors.primaryDarkNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ColTradeAppBar(
        dark: true,
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'API / ERP',
              style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('ENT',
                  style: AppTextStyles.badgeText
                      .copyWith(fontSize: 9, color: Colors.white)),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryDarkNavy,
          unselectedLabelColor: const Color.fromARGB(255, 255, 255, 255),
          indicatorColor: AppColors.accentOrange,
          indicatorWeight: 2.5,
          labelStyle:
              GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Conexiones'),
            Tab(text: 'API Key'),
            Tab(text: 'Sincronización'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConexiones(),
          _buildApiKey(),
          _buildSincronizacion(),
        ],
      ),
    );
  }

  // ── Tab 1: Conexiones ERP ─────────────────────────────────────────────────

  Widget _buildConexiones() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Summary banner
        _buildStatusBanner(),
        const SizedBox(height: 20),

        Text('SISTEMAS DISPONIBLES', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 12),

        ..._erps.map((erp) => _buildErpCard(erp)),

        const SizedBox(height: 20),
        const InfoCard(
          title: 'CREDENCIALES SEGURAS',
          body:
              'Las credenciales de conexión se almacenan cifradas con AES-256. ColTrade nunca almacena contraseñas en texto plano.',
          icon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildStatusBanner() {
    final connected =
        _erps.where((e) => e.status == ErpStatus.connected).length;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDarkNavy, Color(0xFF1E3A5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ESTADO DE INTEGRACIONES',
                    style: AppTextStyles.labelUppercase
                        .copyWith(color: Colors.white60)),
                const SizedBox(height: 6),
                Text(
                  '$connected de ${_erps.length} conectados',
                  style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text('Última sincronización: hace 12 min',
                    style:
                        AppTextStyles.caption.copyWith(color: Colors.white60)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _syncing ? null : _triggerSync,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _syncing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sync_rounded,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text('Sincronizar',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErpCard(ErpSystem erp) {
    final isConnected = erp.status == ErpStatus.connected;
    final isPending = erp.status == ErpStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConnected
              ? AppColors.successGreen.withValues(alpha: 0.3)
              : AppColors.border,
          width: isConnected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: erp.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(erp.icon, color: erp.color, size: 24),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(erp.name, style: AppTextStyles.cardTitle),
                      Text(erp.description, style: AppTextStyles.caption),
                      if (erp.lastSync != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              isConnected
                                  ? Icons.check_circle_rounded
                                  : Icons.schedule_rounded,
                              size: 11,
                              color: isConnected
                                  ? AppColors.successGreen
                                  : AppColors.yellowAmber,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              erp.lastSync!,
                              style: AppTextStyles.caption.copyWith(
                                color: isConnected
                                    ? AppColors.successGreen
                                    : AppColors.yellowAmber,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Status chip
                _statusChip(erp.status),
              ],
            ),
            if (isConnected) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(
                children: [
                  _actionChip(
                    Icons.settings_outlined,
                    'Configurar',
                    onTap: () => _showConfigDialog(erp),
                  ),
                  const SizedBox(width: 8),
                  _actionChip(
                    Icons.sync_rounded,
                    'Sincronizar ahora',
                    onTap: _triggerSync,
                    color: AppColors.successGreen,
                  ),
                  const Spacer(),
                  _actionChip(
                    Icons.link_off_rounded,
                    'Desconectar',
                    onTap: () => _showDisconnectDialog(erp),
                    color: AppColors.errorRed,
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CTAButton(
                  label: isPending ? 'Verificando conexión...' : 'Conectar',
                  onTap: isPending ? null : () => _showConnectDialog(erp),
                  backgroundColor: isPending
                      ? AppColors.yellowAmber
                      : AppColors.primaryDarkNavy,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(ErpStatus status) {
    final (color, label, icon) = switch (status) {
      ErpStatus.connected => (AppColors.successGreen, 'Activo', Icons.circle),
      ErpStatus.disconnected => (
          AppColors.textLabel,
          'Inactivo',
          Icons.circle_outlined
        ),
      ErpStatus.pending => (AppColors.yellowAmber, 'Pendiente', Icons.circle),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 7, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.badgeText.copyWith(
                  color: color, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _actionChip(IconData icon, String label,
      {VoidCallback? onTap, Color? color}) {
    final c = color ?? AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 4),
            Text(label,
                style: AppTextStyles.caption
                    .copyWith(color: c, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Tab 2: API Key ────────────────────────────────────────────────────────

  Widget _buildApiKey() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.darkCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.vpn_key_rounded,
                      color: AppColors.accentOrange, size: 22),
                  const SizedBox(width: 8),
                  Text('Tu API Key',
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
              const SizedBox(height: 14),
              // Key display
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _showApiKey
                            ? _apiKey
                            : '${_apiKey.substring(0, 10)}${'•' * 26}',
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _showApiKey = !_showApiKey),
                      child: Icon(
                        _showApiKey
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: Colors.white54,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _copyApiKey,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.copy_rounded,
                                color: Colors.white70, size: 14),
                            const SizedBox(width: 6),
                            Text('Copiar',
                                style: AppTextStyles.caption
                                    .copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showRegenerateDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.refresh_rounded,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 6),
                            Text('Regenerar',
                                style: AppTextStyles.caption
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('INFORMACIÓN DE LA KEY', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 12),

        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: [
              _infoRow(Icons.badge_outlined, 'Tipo', 'Live Key'),
              const Divider(height: 1),
              _infoRow(Icons.calendar_today_outlined, 'Creada', '15 Mar 2026'),
              const Divider(height: 1),
              _infoRow(Icons.schedule_outlined, 'Expira', 'Nunca'),
              const Divider(height: 1),
              _infoRow(
                  Icons.checklist_rounded, 'Permisos', 'Lectura / Escritura'),
              const Divider(height: 1),
              _infoRow(Icons.bolt_rounded, 'Rate limit', '1,000 req / min'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('WEBHOOK ENDPOINT', style: AppTextStyles.labelUppercase),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'URL de notificaciones de eventos en tiempo real (exportaciones, alertas DIAN, cambios de estado).',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _webhookCtrl,
                keyboardType: TextInputType.url,
                decoration: AppDecorations.inputDecoration(
                  '',
                  'https://tu-servidor.com/webhook',
                  prefix: const Icon(Icons.webhook_rounded,
                      size: 18, color: AppColors.textLabel),
                  suffix: GestureDetector(
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.send_rounded,
                          size: 16, color: AppColors.accentOrange),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CTAButton(
                label: '🔔  Guardar Webhook',
                onTap: () {},
                backgroundColor: AppColors.primaryDarkNavy,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const InfoCard(
          title: 'USO DE LA API',
          body:
              'Usa tu API Key en el header: Authorization: Bearer ct_live_...  Consulta la documentación en docs.coltrade.co',
          icon: Icons.code_rounded,
          borderColor: AppColors.infoBlue,
          bgColor: AppColors.blueLight,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  // ── Tab 3: Sincronización ─────────────────────────────────────────────────

  Widget _buildSincronizacion() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Trigger manual
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF0891B2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sincronización Manual',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Fuerza una sincronización con todos los ERP activos.',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _syncing ? null : _triggerSync,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: _syncing
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Icon(Icons.sync_rounded,
                          color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('CONFIGURACIÓN DE SINCRONIZACIÓN',
            style: AppTextStyles.labelUppercase),
        const SizedBox(height: 12),

        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: [
              _toggleRow(
                Icons.autorenew_rounded,
                'Sincronización automática',
                'Cada 30 minutos con los ERP activos',
                _autoSync,
                (v) => setState(() => _autoSync = v),
              ),
              const Divider(height: 1),
              _toggleRow(
                Icons.upload_rounded,
                'Sincronizar al exportar',
                'Notifica al ERP en cada nueva exportación',
                _syncOnExport,
                (v) => setState(() => _syncOnExport = v),
              ),
              const Divider(height: 1),
              _toggleRow(
                Icons.download_rounded,
                'Sincronizar al importar',
                'Notifica al ERP en cada nueva importación',
                _syncOnImport,
                (v) => setState(() => _syncOnImport = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('HISTORIAL DE SINCRONIZACIÓN',
            style: AppTextStyles.labelUppercase),
        const SizedBox(height: 12),

        Container(
          decoration: AppDecorations.card,
          child: Column(
            children: [
              _syncLogRow('✅', 'SAP Business One', 'Exportación CT-48293',
                  'Hace 12 min', true),
              const Divider(height: 1),
              _syncLogRow('✅', 'SAP Business One', 'Actualización aranceles',
                  'Hace 1 h', true),
              const Divider(height: 1),
              _syncLogRow('❌', 'Oracle NetSuite', 'Timeout de conexión',
                  'Hace 3 h', false),
              const Divider(height: 1),
              _syncLogRow('✅', 'SAP Business One', 'Importación CT-92104',
                  'Hace 5 h', true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        CTAButton(
          label: '📋  Ver log completo',
          outlined: true,
          onTap: () {},
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _toggleRow(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryDarkNavy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.bodyRegular
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryDarkNavy,
          ),
        ],
      ),
    );
  }

  Widget _syncLogRow(
      String emoji, String system, String event, String time, bool success) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system,
                    style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(event, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(time,
              style: AppTextStyles.caption.copyWith(
                color: success ? AppColors.textLabel : AppColors.errorRed,
              )),
        ],
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────

  void _showConfigDialog(ErpSystem erp) {
    final hostCtrl = TextEditingController(text: 'sap.techcorp.com.co');
    final portCtrl = TextEditingController(text: '50000');
    final userCtrl = TextEditingController(text: 'admin_coltrade');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _bottomSheet(
        title: 'Configurar ${erp.name}',
        icon: erp.icon,
        iconColor: erp.color,
        children: [
          _sheetField('SERVIDOR / HOST', hostCtrl,
              icon: Icons.dns_outlined, hint: 'hostname o IP'),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: _sheetField('PUERTO', portCtrl,
                    icon: Icons.settings_ethernet_rounded,
                    hint: '50000',
                    keyboard: TextInputType.number),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _sheetField('USUARIO', userCtrl,
                    icon: Icons.person_outline_rounded, hint: 'b1admin'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _sheetField('CONTRASEÑA', TextEditingController(),
              icon: Icons.lock_outline_rounded,
              hint: '••••••••',
              obscure: true),
          const SizedBox(height: 20),
          CTAButton(
            label: '💾  Guardar configuración',
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),
          CTAButton(
            label: 'Cancelar',
            outlined: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showConnectDialog(ErpSystem erp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _bottomSheet(
        title: 'Conectar ${erp.name}',
        icon: erp.icon,
        iconColor: erp.color,
        children: [
          _sheetField('SERVIDOR / HOST', TextEditingController(),
              icon: Icons.dns_outlined, hint: 'hostname o IP'),
          const SizedBox(height: 14),
          _sheetField('USUARIO', TextEditingController(),
              icon: Icons.person_outline_rounded, hint: 'usuario'),
          const SizedBox(height: 14),
          _sheetField('CONTRASEÑA / TOKEN', TextEditingController(),
              icon: Icons.lock_outline_rounded,
              hint: '••••••••',
              obscure: true),
          const SizedBox(height: 20),
          CTAButton(
            label: '🔗  Establecer conexión',
            onTap: () => Navigator.pop(context),
            backgroundColor: erp.color,
          ),
          const SizedBox(height: 10),
          CTAButton(
            label: 'Cancelar',
            outlined: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog(ErpSystem erp) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Desconectar ${erp.name}', style: AppTextStyles.cardTitle),
        content: Text(
          'Al desconectar se detendrá la sincronización automática. Los datos ya sincronizados no se eliminarán.',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Desconectar',
                style: GoogleFonts.inter(
                    color: AppColors.errorRed, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showRegenerateDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('¿Regenerar API Key?', style: AppTextStyles.cardTitle),
        content: Text(
          'La key actual quedará inválida inmediatamente. Deberás actualizar todas las integraciones que la usen.',
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Regenerar',
                style: GoogleFonts.inter(
                    color: AppColors.errorRed, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Bottom Sheet Helper ────────────────────────────────────────────────────

  Widget _bottomSheet({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _sheetField(
    String label,
    TextEditingController ctrl, {
    required IconData icon,
    required String hint,
    TextInputType? keyboard,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelUppercase),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          obscureText: obscure,
          decoration: AppDecorations.inputDecoration(
            '',
            hint,
            prefix: Icon(icon, size: 18, color: AppColors.textLabel),
          ),
        ),
      ],
    );
  }
}
