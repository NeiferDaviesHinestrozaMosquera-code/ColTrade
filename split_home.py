import os
import re

base_path = r'C:\Users\User\coltrade\lib\features\home\presentation'
screen_path = os.path.join(base_path, 'screens', 'home_screen.dart')
widgets_path = os.path.join(base_path, 'widgets')

if not os.path.exists(widgets_path):
    os.makedirs(widgets_path)

with open(screen_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace "Widget _build..." with "class ... extends StatelessWidget"
# Actually, let's just create new files and copy the methods into them, 
# then wrap them in a StatelessWidget class.

def extract_block(text, start_marker, end_marker):
    start = text.find(start_marker)
    end = text.find(end_marker, start)
    return text[start:end]

dashboard_code = extract_block(content, "  // ── Dashboard", "  // ── Operaciones")
operations_code = extract_block(content, "  // ── Operaciones", "  // ── Herramientas")
tools_code = extract_block(content, "  // ── Herramientas", "  // ── Perfil")
profile_code = extract_block(content, "  // ── Perfil", "  // ── Bottom Navigation")

imports = """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../alerts/presentation/screens/alerts_screen.dart';
import '../../../checklist/presentation/screens/checklist_screen.dart';
import '../../../calculator/presentation/screens/calculator_screen.dart';
import '../../../security/presentation/screens/security_screen.dart';
import '../bloc/home_bloc.dart';
import '../../../assistant/presentation/screens/export_assistant_screen.dart';
import '../../../assistant/presentation/screens/import_assistant_screen.dart';
import '../../../academy/presentation/screens/knowledge_center_screen.dart';
import '../../../assistant/presentation/screens/nandina_classifier_screen.dart';
import '../../../assistant/presentation/screens/agents_screen.dart';
import '../../../profile/presentation/screens/personal_info_screen.dart';
import '../../../profile/presentation/screens/company_info_screen.dart';
import '../../../profile/presentation/screens/notifications_screen.dart';
import '../../../profile/presentation/screens/notification_settings_screen.dart';
import '../../../profile/presentation/screens/my_tickets_screen.dart';
import '../../../profile/presentation/screens/tutorials_screen.dart';
import '../../../profile/presentation/screens/support_screen.dart';
import '../../../erp/presentation/screens/api_erp_screen.dart';
import '../../../logistics/presentation/screens/logistics_screen.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../../../repository/presentation/screens/repository_screen.dart';
"""

def make_class(name, code, build_method_name):
    # remove the original build method declaration and replace with build(BuildContext context)
    code = code.replace(f"  Widget {build_method_name}(BuildContext context) {{", f"  @override\n  Widget build(BuildContext context) {{")
    return imports + f"\nclass {name} extends StatelessWidget {{\n  const {name}({{super.key}});\n\n{code}\n}}\n"

with open(os.path.join(widgets_path, 'dashboard_tab.dart'), 'w', encoding='utf-8') as f:
    f.write(make_class('DashboardTab', dashboard_code, '_buildDashboard'))

with open(os.path.join(widgets_path, 'operations_tab.dart'), 'w', encoding='utf-8') as f:
    f.write(make_class('OperationsTab', operations_code, '_buildOperaciones'))

with open(os.path.join(widgets_path, 'tools_tab.dart'), 'w', encoding='utf-8') as f:
    f.write(make_class('ToolsTab', tools_code, '_buildHerramientas'))

with open(os.path.join(widgets_path, 'profile_tab.dart'), 'w', encoding='utf-8') as f:
    f.write(make_class('ProfileTab', profile_code, '_buildPerfil'))

print("Extracted successfully!")
