# 🚀 Prueba Técnica Flutter - Double V Partners

Aplicación móvil desarrollada en Flutter que implementa un sistema completo de registro de usuarios con gestión de direcciones, siguiendo principios de **Clean Architecture** y mejores prácticas de desarrollo.

## 📋 Descripción del Proyecto

Esta aplicación fue desarrollada como parte de la prueba técnica para **Double V Partners NYX**. Implementa un flujo completo de registro de usuario con las siguientes funcionalidades:

### ✨ Características Principales

- **🧑‍💼 Registro de Usuario**: Nombre, apellido y fecha de nacimiento
- **🏠 Gestión de Direcciones**: Múltiples direcciones por usuario con país, estado y ciudad
- **💾 Persistencia Local**: Almacenamiento seguro usando FlutterSecureStorage
- **🎨 UI Moderna**: Interfaz elegante con Material Design 3
- **🏗️ Clean Architecture**: Separación clara de responsabilidades
- **🔄 Estado Reactivo**: Gestión de estado con Riverpod
- **📱 UX Optimizada**: Navegación intuitiva y validaciones en tiempo real

## 🏛️ Arquitectura del Proyecto

### Clean Architecture Implementation

```
lib/
├── core/                     # Núcleo compartido
│   ├── constants/           # Constantes globales
│   ├── di/                 # Inyección de dependencias (GetIt)
│   ├── errors/             # Manejo de errores y excepciones
│   ├── network/            # Configuración de red
│   ├── router/             # Navegación (GoRouter)
│   ├── services/           # Servicios transversales
│   ├── utils/              # Utilidades y helpers
│   └── widgets/            # Componentes UI reutilizables
│
├── features/               # Características por dominio
│   ├── auth/              # Autenticación y registro
│   │   ├── domain/        # Entidades, repositorios, use cases
│   │   ├── data/          # Implementaciones y fuentes de datos
│   │   └── presentation/  # UI, providers, páginas
│   │
│   ├── addresses/         # Gestión de direcciones
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── profile/           # Perfil de usuario
│       ├── domain/
│       ├── data/
│       └── presentation/
│
└── main.dart              # Punto de entrada
```

### 🏗️ Principios Aplicados

- **🎯 Single Responsibility Principle**: Cada clase tiene una sola responsabilidad
- **🔓 Open/Closed Principle**: Abierto para extensión, cerrado para modificación
- **🔄 Dependency Inversion**: Dependencias hacia abstracciones, no concreciones
- **📦 Separation of Concerns**: Separación clara entre capas
- **🧩 Repository Pattern**: Abstracción de fuentes de datos
- **🎭 Provider Pattern**: Gestión de estado reactivo

## 📱 Flujo de la Aplicación

### Pantalla de Inicio (`AuthCheckScreen`)
- Verifica automáticamente si el usuario está registrado
- Redirige inteligentemente según el estado de los datos

### 🏃‍♂️ Flujo Principal

1. **📝 Registro de Usuario** (`UserRegistrationPage`)
   - Validación de nombres (solo letras y espacios)
   - Selector de fecha de nacimiento

2. **🌍 Agregar Dirección** (`AddAddressPage`)
   - Selección de país, estado y ciudad
   - Carga dinámica de estados y ciudades
   - Validación completa del formulario
   - Persistencia automática

3. **👤 Perfil de Usuario** (`UserProfilePage`)
   - Visualización completa de información personal
   - Lista de todas las direcciones registradas
   - Opción para agregar más direcciones
   - Funcionalidad de cierre de sesión

## 🔧 Tecnologías y Dependencias

### 📦 Dependencias Principales

```yaml
dependencies:
  flutter: ^3.x.x
  flutter_riverpod: ^2.4.9      # Gestión de estado reactivo
  go_router: ^12.1.3            # Navegación declarativa
  flutter_secure_storage: ^9.0.0 # Almacenamiento seguro
  get_it: ^7.6.4                # Inyección de dependencias
  dio: ^5.3.2                   # Cliente HTTP
  hugeicons: ^0.0.6             # Iconografía moderna
  intl: ^0.19.0                 # Internacionalización
```

### 🛠️ Herramientas de Desarrollo

- **🎨 Material Design 3**: Sistema de diseño moderno
- **🔍 Flutter Analyze**: Análisis estático de código
- **📐 Dart Format**: Formateo automático de código
- **🧪 Testing Ready**: Estructura preparada para pruebas unitarias

## 🎨 Características de UI/UX

### 🎭 Componentes Personalizados

- **CustomInput**: Campo de texto con validaciones avanzadas
- **CustomButton**: Botones con estados de carga y estilos consistentes
- **CustomCard**: Tarjetas con elevación y bordes redondeados
- **ProfileHeader**: Encabezado de perfil con avatar y información
- **ProfileSection**: Secciones organizadas del perfil

### 🎯 Experiencia de Usuario

- ✅ **Validaciones en Tiempo Real**: Feedback inmediato al usuario
- ✅ **Estados de Carga**: Indicadores visuales durante operaciones
- ✅ **Manejo de Errores**: Mensajes claros y útiles
- ✅ **Navegación Intuitiva**: Flujo lógico entre pantallas
- ✅ **Teclado Inteligente**: Se cierra al tocar fuera de los campos
- ✅ **Diseño Responsive**: Adaptable a diferentes tamaños de pantalla

## 🚀 Cómo Ejecutar el Proyecto

### 📋 Prerrequisitos

```bash
# Verificar instalación de Flutter
flutter doctor

# Versión mínima requerida: Flutter 3.16.0+
```

### 🏃‍♂️ Instalación y Ejecución

```bash
# 1. Clonar el repositorio
git clone [URL_DEL_REPOSITORIO]
cd dvp_prueba_tecnica_flutter

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar la aplicación
flutter run

# 4. Ejecutar análisis de código
flutter analyze

# 5. Formatear código
dart format lib/
```

### 📱 Dispositivos Soportados

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Emuladores**: Android Studio AVD, iOS Simulator

## 🗂️ Estructura de Features

### 🔐 Auth Feature
**Responsabilidades**: Autenticación, registro y gestión de sesión

```
auth/
├── domain/
│   ├── entities/
│   │   └── user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── use_cases/
│       ├── register_user_use_case.dart
│       ├── get_current_user_use_case.dart
│       ├── logout_use_case.dart
│       └── is_authenticated_use_case.dart
├── data/
│   ├── datasources/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── pages/
    └── widgets/
```

### 📍 Addresses Feature
**Responsabilidades**: Gestión de ubicaciones y direcciones

```
addresses/
├── domain/
│   ├── entities/
│   │   ├── country.dart
│   │   ├── state.dart
│   │   ├── city.dart
│   │   └── address.dart
│   ├── repositories/
│   │   └── location_repository.dart
│   └── usecases/
│       ├── get_countries_use_case.dart
│       ├── get_states_by_country_use_case.dart
│       └── get_cities_by_state_use_case.dart
├── data/
└── presentation/
```

### 👤 Profile Feature
**Responsabilidades**: Visualización del perfil de usuario

```
profile/
├── domain/
│   ├── repositories/
│   │   └── profile_repository.dart
│   └── use_cases/
│       ├── get_user_profile_use_case.dart
│       ├── add_address_to_profile_use_case.dart
│       └── refresh_profile_use_case.dart
├── data/
└── presentation/
```

## 🔒 Gestión de Datos

### 💾 Persistencia Local

- **FlutterSecureStorage**: Almacenamiento seguro de datos del usuario
- **Serialización JSON**: Conversión eficiente de objetos Dart
- **Estado Reactivo**: Sincronización automática entre storage y UI

### 📊 Flujo de Datos

```
UI (Widget) 
    ↕️ 
Provider/Notifier 
    ↕️ 
Use Case 
    ↕️ 
Repository (Interface) 
    ↕️ 
Repository Implementation 
    ↕️ 
Data Source 
    ↕️ 
Storage/API
```

## 🧪 Calidad del Código

### ✅ Buenas Prácticas Implementadas

- **📝 Documentación**: Comentarios claros
- **🎯 Naming Conventions**: Nomenclatura descriptiva y consistente
- **🔄 Error Handling**: Manejo robusto de excepciones
- **🧩 Modularity**: Código modular y reutilizable
- **📐 Consistent Formatting**: Formateo automático con dart format
- **🔍 Static Analysis**: Análisis estático con flutter analyze

### 🎯 Principios SOLID Aplicados

1. **S** - Single Responsibility: Cada clase tiene una responsabilidad específica
2. **O** - Open/Closed: Abierto para extensión, cerrado para modificación
3. **L** - Liskov Substitution: Las implementaciones son intercambiables
4. **I** - Interface Segregation: Interfaces específicas y cohesivas
5. **D** - Dependency Inversion: Dependencias hacia abstracciones

## 🎉 Características Destacadas

### 🚀 Startup Inteligente
- Detección automática del estado de la aplicación
- Navegación inteligente basada en datos existentes
- Experiencia fluida sin pasos redundantes

### 🛡️ Validaciones Avanzadas
- Campos de nombre solo permiten letras y espacios
- Validación de fecha de nacimiento (18+ años)
- Formatters en tiempo real para prevenir caracteres especiales
- Mensajes de error claros y útiles

### 🎨 UI/UX Premium
- Material Design 3 con colores y tipografías modernas
- Estados de carga y feedback visual inmediato

### 🏗️ Arquitectura Escalable
- Separación clara entre capas
- Fácil testing y mantenimiento
- Preparado para crecimiento de features
- Código reutilizable y modular

## 🤝 Desarrollado Por

**Sebastian Agudelo A**  
Desarrollador Flutter con experiencia en Clean Architecture y mejores prácticas de desarrollo móvil.


*Esta aplicación fue desarrollada como parte del proceso de selección para **Double V Partners NYX**, demostrando conocimientos en Flutter, Clean Architecture, principios SOLID y mejores prácticas de desarrollo móvil.*
