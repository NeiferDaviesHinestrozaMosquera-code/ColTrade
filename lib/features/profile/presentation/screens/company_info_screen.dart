import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class CompanyInfoScreen extends StatefulWidget {
  const CompanyInfoScreen({super.key});

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _razonSocialCtrl =
      TextEditingController(text: 'TechCorp Solutions S.A.S.');
  final _nitCtrl = TextEditingController(text: '900.123.456-7');
  final _direccionCtrl = TextEditingController(text: 'Cra. 7 # 32-16, Piso 5');
  final _ciudadCtrl = TextEditingController(text: 'Bogotá');
  final _departamentoCtrl = TextEditingController(text: 'Cundinamarca');
  final _emailEmpresaCtrl =
      TextEditingController(text: 'contacto@techcorp.com.co');
  final _telefonoEmpresaCtrl = TextEditingController(text: '+57 601 234 5678');

  String? _actividadEconomica;
  String? _regimenTributario;

  final _actividades = [
    'Comercio al por mayor',
    'Comercio al por menor',
    'Manufactura / Industria',
    'Agricultura y agroindustria',
    'Minería y energía',
    'Servicios profesionales',
    'Tecnología',
    'Transporte y logística',
    'Turismo y hotelería',
  ];

  final _regimenes = [
    'Régimen Simple de Tributación',
    'Régimen Ordinario',
    'Gran Contribuyente',
    'Régimen Especial',
  ];

  @override
  void dispose() {
    _razonSocialCtrl.dispose();
    _nitCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _departamentoCtrl.dispose();
    _emailEmpresaCtrl.dispose();
    _telefonoEmpresaCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    
    final companyData = {
      'razonSocial': _razonSocialCtrl.text,
      'nit': _nitCtrl.text,
      'direccion': _direccionCtrl.text,
      'ciudad': _ciudadCtrl.text,
      'departamento': _departamentoCtrl.text,
      'email': _emailEmpresaCtrl.text,
      'telefono': _telefonoEmpresaCtrl.text,
      'actividad': _actividadEconomica,
      'regimen': _regimenTributario,
    };
    
    context.read<ProfileBloc>().add(UpdateCompanyProfileEvent(companyData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ColTradeAppBar(
        title: 'Datos de Empresa',
        dark: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Datos de empresa guardados',
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                backgroundColor: AppColors.successGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(16),
              ),
            );
          } else if (state is ProfileUpdateError) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(
                 content: Text('Error al guardar: ${state.message}',
                     style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
                 backgroundColor: AppColors.errorRed,
                 behavior: SnackBarBehavior.floating,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                 margin: const EdgeInsets.all(16),
               ),
             );
          }
        },
        builder: (context, state) {
          final isSaving = state is ProfileUpdating;
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
            // ── Company Header Card ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card,
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.business_rounded,
                        color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _razonSocialCtrl.text,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text('NIT: ${_nitCtrl.text}',
                            style: AppTextStyles.caption),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accentOrange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('PLAN PRO',
                                  style: AppTextStyles.badgeText.copyWith(
                                      color: Colors.white, fontSize: 9)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: AppColors.successGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('DIAN Verificada',
                                      style: AppTextStyles.badgeText.copyWith(
                                          color: AppColors.successGreen,
                                          fontSize: 9)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Identificación Tributaria ──────────────────────────────────
            _sectionLabel('IDENTIFICACIÓN TRIBUTARIA'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('RAZÓN SOCIAL'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _razonSocialCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'Nombre legal de la empresa',
                      prefix: const Icon(Icons.apartment_rounded,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('NIT'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nitCtrl,
                    keyboardType: TextInputType.number,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '900.000.000-0',
                      prefix: const Icon(Icons.tag_rounded,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('RÉGIMEN TRIBUTARIO'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _regimenTributario,
                    hint: Text('Selecciona régimen',
                        style: AppTextStyles.bodySmall),
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '',
                      prefix: const Icon(Icons.account_balance_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    items: _regimenes
                        .map((r) => DropdownMenuItem(
                              value: r,
                              child: Text(r,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _regimenTributario = v),
                    isExpanded: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Ubicación ──────────────────────────────────────────────────
            _sectionLabel('UBICACIÓN'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('DIRECCIÓN PRINCIPAL'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _direccionCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'Calle, Carrera, Avenida...',
                      prefix: const Icon(Icons.location_on_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('CIUDAD'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _ciudadCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  AppDecorations.inputDecoration('', 'Ciudad'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Requerido'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _fieldLabel('DEPARTAMENTO'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _departamentoCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: AppDecorations.inputDecoration(
                                  '', 'Departamento'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Requerido'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Actividad y Contacto ───────────────────────────────────────
            _sectionLabel('ACTIVIDAD Y CONTACTO'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('ACTIVIDAD ECONÓMICA'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _actividadEconomica,
                    hint: Text('Selecciona actividad',
                        style: AppTextStyles.bodySmall),
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '',
                      prefix: const Icon(Icons.category_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    items: _actividades
                        .map((a) => DropdownMenuItem(
                              value: a,
                              child: Text(a,
                                  style: const TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _actividadEconomica = v),
                    isExpanded: true,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('CORREO EMPRESARIAL'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailEmpresaCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'contacto@empresa.com',
                      prefix: const Icon(Icons.mail_outline_rounded,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Campo requerido';
                      if (!v.contains('@')) return 'Correo inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('TELÉFONO EMPRESARIAL'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _telefonoEmpresaCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '+57 601 000 0000',
                      prefix: const Icon(Icons.phone_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Info DIAN ──────────────────────────────────────────────────
            const InfoCard(
              title: 'VERIFICACIÓN DIAN',
              body:
                  'Los cambios en NIT o Razón Social deben reflejarse correctamente en el RUT registrado ante la DIAN. Actualiza tus datos con cuidado.',
              borderColor: AppColors.yellowAmber,
              bgColor: AppColors.amberLight,
              icon: Icons.warning_amber_rounded,
            ),
            const SizedBox(height: 28),

            CTAButton(
              label: isSaving ? 'Guardando...' : '✅  Guardar Empresa',
              onTap: isSaving ? null : _onSave,
              backgroundColor: AppColors.accentOrange,
            ),
            const SizedBox(height: 16),
            CTAButton(
              label: 'Cancelar',
              outlined: true,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);

  Widget _fieldLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);
}

