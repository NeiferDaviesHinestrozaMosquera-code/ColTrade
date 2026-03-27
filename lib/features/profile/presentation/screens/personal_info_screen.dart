import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController(text: 'Carlos Rodriguez');
  final _emailCtrl = TextEditingController(text: 'carlos@techcorp.com.co');
  final _telefonoCtrl = TextEditingController(text: '+57 300 456 7890');
  final _docNumCtrl = TextEditingController(text: '1.052.345.678');
  final _cargoCtrl =
      TextEditingController(text: 'Gerente de Comercio Exterior');
  final _ciudadCtrl = TextEditingController(text: 'Bogotá D.C.');

  String _tipoDoc = 'CC';
  bool _saving = false;

  final _tiposDoc = ['CC', 'CE', 'NIT', 'Pasaporte', 'TI'];

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _telefonoCtrl.dispose();
    _docNumCtrl.dispose();
    _cargoCtrl.dispose();
    _ciudadCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Información personal guardada',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white)),
        backgroundColor: AppColors.successGreen,
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
        title: 'Información Personal',
        dark: true,
        actions: [
          TextButton(
            onPressed: _saving ? null : _onSave,
            child: Text(
              'Guardar',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentOrange,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Avatar Card ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppDecorations.card,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDarkNavy,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'CR',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(
                              color: AppColors.accentOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nombreCtrl.text,
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDarkNavy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('PLAN PRO',
                        style: AppTextStyles.badgeText
                            .copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Datos Personales ───────────────────────────────────────────
            _sectionLabel('DATOS PERSONALES'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('NOMBRE COMPLETO'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nombreCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'Ej. Carlos Rodriguez',
                      prefix: const Icon(Icons.person_outline_rounded,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),

                  _fieldLabel('CORREO ELECTRÓNICO'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'correo@empresa.com',
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

                  _fieldLabel('TELÉFONO / CELULAR'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _telefonoCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      '+57 300 000 0000',
                      prefix: const Icon(Icons.phone_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // ── Tipo + N° doc ──────────────────────────────────────
                  _fieldLabel('DOCUMENTO DE IDENTIDAD'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: _tipoDoc,
                          decoration: AppDecorations.inputDecoration('', ''),
                          items: _tiposDoc
                              .map((t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t,
                                        style: const TextStyle(fontSize: 13)),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _tipoDoc = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _docNumCtrl,
                          keyboardType: TextInputType.number,
                          decoration: AppDecorations.inputDecoration(
                              '', 'Número de documento'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Datos Laborales ────────────────────────────────────────────
            _sectionLabel('DATOS LABORALES'),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppDecorations.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('CARGO / ROL'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cargoCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'Ej. Gerente de Comercio Exterior',
                      prefix: const Icon(Icons.work_outline_rounded,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  _fieldLabel('CIUDAD DE RESIDENCIA'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _ciudadCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: AppDecorations.inputDecoration(
                      '',
                      'Ej. Bogotá D.C.',
                      prefix: const Icon(Icons.location_on_outlined,
                          size: 18, color: AppColors.textLabel),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Campo requerido'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            CTAButton(
              label: _saving ? 'Guardando...' : '✅  Guardar Cambios',
              onTap: _saving ? null : _onSave,
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
      ),
    );
  }

  Widget _sectionLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);

  Widget _fieldLabel(String label) =>
      Text(label, style: AppTextStyles.labelUppercase);
}

