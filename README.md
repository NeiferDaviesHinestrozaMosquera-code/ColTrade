# ColTrade

ColTrade es una innovadora aplicación móvil construida en **Flutter** diseñada para simplificar, guiar y optimizar las operaciones de importación y exportación de mercancías en Colombia. Ofrece un ecosistema de herramientas logísticas, aduaneras y de gestión para empresas (MiPymes y Corporativas) y profesionales del comercio exterior.

---

## 🚀 Características Principales

La aplicación cuenta con características robustas y profesionales enfocadas en la fluidez de trabajo y asistencia aduanera:

*   **Asistente Inteligente (AI Assistant):** Un motor tipo chat para resolver dudas comerciales y el **Clasificador Nandina**, el cual busca de forma instantánea subpartidas arancelarias reales a partir de coincidencias de texto almacenadas de forma local.
*   **Logística Interactiva:** Sección avanzada con mapas interactivos de rutas y puertos, permitiendo visualizar alternativas de transporte (Aéreo, Marítimo, Terrestre) con animaciones de origen y destino.
*   **Directorio de Agentes Aduaneros:** Listado de agentes expertos ("ColTrade Agents") con perfiles inmersivos y una interfaz integrada para enviar requerimientos de contacto directo.
*   **Repositorio de Documentos Real:** Un gestor documental para organizar y buscar archivos usando múltiples filtros. Permite **subir archivos reales** desde el dispositivo mediante el sistema de archivos nativo, calculando dinámicamente sus tamaños, extensiones y asignando categorías automáticamente.
*   **Descargas con Progreso Interactivo:** Diálogos visuales animados que simulan y muestran el progreso de descarga de documentos en tiempo real, permitiendo al usuario abrir el archivo local directamente una vez completado.
*   **Historial de Consultas Persistente:** Potente sección que registra las operaciones previas (aranceles, cotizaciones, checklists) usando un avanzado motor de intersección (filtros por fecha, importancia y texto simultáneos).
*   **Soporte Biométrico:** Integración de biometría local (Huella/FaceID) activable mediante un toggle interactivo en el panel de configuración de seguridad.
*   **Modo Offline y Sincronización:** Registro automático de sincronizaciones programadas en segundo plano mediante `SyncService` y monitorización de red estable con `ConnectivityService`.

---

## 🏗 Arquitectura y Patrones Profesionales

ColTrade está construida rigurosamente utilizando **Clean Architecture** y el patrón de gestión de estados **BLoC**, asegurando escalabilidad, testeabilidad y separación de responsabilidades:

1.  **Capa de Dominio (Domain):** Contiene Modelos/Entidades, Repositorios (Interfaces) y Casos de Uso (Use Cases). Totalmente independiente del framework o de plataformas externas.
2.  **Capa de Datos (Data):** Contiene las implementaciones de los repositorios, orígenes de datos locales (`LocalDatabase` con **SQLite**) y modelos de datos de red (DTOs).
3.  **Capa de Presentación (Presentation):** Define la Interfaz de Usuario (Widgets/Screens) y conecta eventos del UI a través del patrón `Bloc` (Business Logic Component).

### Inyección de Dependencias
Se unificó la inyección de dependencias a través de **GetIt** en el archivo [injection.dart](lib/injection/injection.dart). Todos los DataSources, Repositorios, Casos de Uso y BLoCs son registrados e inyectados de forma centralizada utilizando `sl<T>()` en toda la aplicación, evitando dependencias manuales.

### Estructura de Directorios

El código fuente bajo `lib/` está segmentado modularmente por _Features_ funcionales:

```
lib/
├── core/                  # Elementos centrales compartidos (Tema, Base de datos, Servicios, Widgets)
│   ├── data/              # Base de datos SQLite local (local_database.dart)
│   ├── services/          # Servicios comunes (conectividad, sincronización, biometría)
│   ├── theme/             # Colores corporativos (AppColors), tipografía (AppTextStyles)
│   └── widgets/           # Componentes base como ColTradeAppBar, etc.
├── features/              # Divisiones funcionales aisladas (Módulos)
│   ├── auth/              # Lógica y Vistas de Login / Registro
│   ├── assistant/         # Vistas del Chatbot, Clasificador Nandina, y Perfiles de Agentes
│   ├── checklist/         # Listas de verificación y tareas asociadas al comercio exterior
│   ├── history/           # Módulo de Historial persistente en SQLite
│   ├── home/              # Interfaz y Bottom bar principal 
│   ├── logistics/         # Módulo de simulación de puertos y rutas 
│   ├── profile/           # Ajustes de perfil, planes de suscripción y notificaciones
│   └── repository/        # Explorador y gestor de carga y descarga de documentos reales
├── injection/             # Contenedor de Inyección de Dependencias (injection.dart)
└── main.dart              # Punto de entrada de la aplicación
```

---

## 🛠 Tecnologías y Librerías Destacadas

*   **[Flutter SDK](https://flutter.dev/):** Framework UI multiplataforma nativo.
*   **[flutter_bloc](https://pub.dev/packages/flutter_bloc):** Manejo predecible de estados reactivos.
*   **[get_it](https://pub.dev/packages/get_it):** Contenedor liviano para inyección de dependencias (Service Locator).
*   **[sqflite](https://pub.dev/packages/sqflite):** Persistencia SQL local para SQLite.
*   **[file_picker](https://pub.dev/packages/file_picker):** Selección nativa de archivos desde almacenamiento móvil y escritorio.
*   **[local_auth](https://pub.dev/packages/local_auth):** Soporte para autenticación biométrica segura en dispositivos físicos.
*   **[flutter_image_compress](https://pub.dev/packages/flutter_image_compress):** Compresión de imágenes de cámara previas a la subida.
*   **[google_fonts](https://pub.dev/packages/google_fonts):** Tipografías premium (*Inter*, *Outfit*).
*   **[intl](https://pub.dev/packages/intl):** Formateo localizado de fechas y valores monetarios.

---

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
Puedes asegurar que la base de código mantenga los estándares ejecutando en la terminal:
```bash
flutter analyze
```

---

## 🎨 UI / UX Design

El diseño visual ha sido elaborado para proyectar confianza, rapidez y modernidad en un sector complejo como lo es el comercio internacional:
*   **Paleta de Colores (`AppColors`):** Utiliza un Azul Marino vibrante (`primaryDarkNavy`) como base corporativa, y Naranja de Acento (`accentOrange`) para destacar elementos _Call-to-Action_ intuitivos.
*   **Tipografía de Precisión:** Conectada a Google Fonts, aplicando familias tipográficas legibles e indicadas para lectura densa de metadatos arancelarios y logísticos.
