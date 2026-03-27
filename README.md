# ColTrade

ColTrade es una innovadora aplicación móvil construida en **Flutter** diseñada para simplificar, guiar y optimizar las operaciones de importación y exportación de mercancías en Colombia. Ofrece un ecosistema de herramientas logísticas, aduaneras y de gestión para empresas (MiPymes y Corporativas) y profesionales del comercio exterior.

## 🚀 Características Principales

La aplicación cuenta con características robustas enfocadas en la fluidez de trabajo y asistencia aduanera:

*   **Asistente Inteligente (AI Assistant):** Un motor tipo chat para resolver dudas comerciales y el **Clasificador Nandina**, diseñado para ayudar en la identificación de aranceles correctos.
*   **Logística Interactiva:** Sección avanzada con mapas interactivos de rutas y puertos, permitiendo visualizar alternativas de transporte (Aéreo, Marítimo, Terrestre) con animaciones de origen y destino.
*   **Directorio de Agentes Aduaneros:** Listado de agentes expertos ("ColTrade Agents") con perfiles inmersivos y una interfaz integrada para enviar requerimientos de contacto directo.
*   **Repositorio de Documentos:** Un gestor documental simulado para organizar, buscar mediante múltiples filtros, descargar (mock) y subir (mock) facturas, manifiestos de carga, BLs, y certificados.
*   **Historial de Consultas:** Potente sección que registra las operaciones previas (aranceles, cotizaciones, checklists) usando un avanzado motor de intersección (filtros por fecha, importancia y texto simultáneos).
*   **Panel de Perfil y Notificaciones:** Ajustes granulares de alertas (Email y Push) para cambios regulatorios DIAN, actualizaciones de envío y mensajes de agentes.

## 🏗 Arquitectura y Patrones Convencionales

ColTrade fue construida rigurosamente utilizando **Clean Architecture** y el patrón de gestión de estados **BLoC**, asegurando escalabilidad, testeabilidad y separación de responsabilidades:

1.  **Capa de Dominio (Domain):** Contiene Modelos/Entidades, Repositorios (Interfaces) y Casos de Uso (Use Cases). Totalmente independiente del framework o de plataformas externas.
2.  **Capa de Datos (Data):** Contiene Implementaciones de Repositorios, Datasources Locales/Remotos y Modelos de datos de red (DTOs).
3.  **Capa de Presentación (Presentation):** Define la Interfaz de Usuario (Widgets/Screens) y conecta eventos del UI a través del patrón `Bloc` (Business Logic Component) y `Cubit`.

### Estructura de Directorios

El código fuente bajo `lib/` está segmentado modularmente por _Features_ funcionales:

```
lib/
├── core/                  # Elementos centrales compartidos (Tema, Widgets, Utils, Red)
│   ├── theme/             # Colores corporativos (AppColors), tipografía (AppTextStyles)
│   └── widgets/           # Componentes base como ColTradeAppBar, NotificationBell, etc.
├── features/              # Divisiones funcionales aisladas
│   ├── auth/              # Lógica y Vistas de Login / Registo
│   ├── assistant/         # Vistas del Chatbot, Clasificador Nandina, y Perfiles de Agentes
│   ├── history/           # Módulo de Historial con múltiples filtros
│   ├── home/              # Interfaz y Bottom bar principal 
│   ├── logistics/         # Módulo de simulación de puertos y rutas 
│   ├── profile/           # Ajustes de perfil, facturación y preferencias de notificaciones
│   └── repository/        # Explorador y gestor de carga de documentos (DocumentCard / Bloc)
└── main.dart              # Punto de entrada de la aplicación
```

## 🛠 Tecnologías y Librerías Destacadas

*   **[Flutter SDK](https://flutter.dev/):** Framework UI multiplataforma nativo.
*   **[flutter_bloc](https://pub.dev/packages/flutter_bloc):** Manejo predecible del estado mediante flujos de eventos.
*   **[equatable](https://pub.dev/packages/equatable):** Facilita la comparación de instancias de forma nativa para BLoC.
*   **[google_fonts](https://pub.dev/packages/google_fonts):** Tipografías modernas (*Inter*, *Outfit*).
*   **[intl](https://pub.dev/packages/intl):** Formateo estricto de fechas y valores monetarios.

## 💻 Instrucciones de Ejecución Local

Para levantar este proyecto en tu entorno local:

1.  **Requisitos:** 
    Tener instalado [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión compatible más reciente) y un emulador/simulador o dispositivo físico configurado.
2.  **Clonar este repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/coltrade.git
    cd coltrade
    ```
3.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```
4.  **Ejecutar la aplicación:**
    ```bash
    flutter run
    ```
    
*(Opcional - Verificación de código)*
Puedes asegurar que la base de código mantenga los estándares ejecutando en el terminal:
`flutter analyze`

## 🎨 UI / UX Design

El diseño visual de la base fue adaptado para proyectar confianza, velocidad y modernidad en un nicho B2B complejo como las importaciones y aduanas. Los esquemas adoptados (`AppColors`) utilizan una paleta que varía desde un Azul Marino vibrante (`primaryDarkNavy`) como base corporativa, contrastando dinámicamente con Naranja de Acento (`accentOrange`) para potenciar botones _Call-to-Action_ de manera intuitiva y amigable.
