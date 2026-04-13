# Matuteca - Documentación de Arquitectura

## Descripción del Proyecto

Matuteca es una aplicación móvil que permite a estudiantes de bachillerato estudiar matemáticas para la prueba ICFES. Los usuarios pueden avanzar a su ritmo, pre-descargar cursos para uso offline, y practicar con un banco de preguntas.

---

## Estilo Arquitectónico

### Capas (Layers)

**Problema que resuelve:** Organiza el código en capas lógicas con responsabilidades separadas. Cada capa solo se comunica con las capas adyacentes, facilitando el mantenimiento y el desarrollo en paralelo.

**Donde se aplica:** Estructura general de toda la aplicación. Define las capas de presentación (UI), lógica de negocio (servicios), acceso a datos (repositorios) e infraestructura (almacenamiento local y APIs).

---

## Patrones Arquitectónicos

### 4. Event-Driven (Orientado a Eventos)

**Problema que resuelve:** Permite que componentes independientes se comuniquen sin conocerse directamente. Cuando ocurre una acción (ej: completar lección), múltiples servicios deben reaccionar (actualizar progreso, verificar achievements, sincronizar offline) sin acoplamiento directo entre ellos.

**Donde se aplica:** En la comunicación entre servicios del dominio y la capa de presentación. Gestiona eventos como completación de lecciones, respuestas de quiz, desbloqueo de logros y sincronización de progreso.

---

### 5. Presentation Layer

**Problema que resuelve:** Separa la lógica de transformación de datos de la interfaz de usuario. Evita que las pantallas (screens) acumulen lógica de negocio y las mantiene simples, focusing only en renderizar.

**Donde se aplica:** En todas las pantallas de la aplicación (Home, Cursos, Lecciones, Quiz, Perfil). Cada pantalla tiene un presentador dedicado que prepara los datos y maneja las interacciones del usuario.

---

## Patrones de Diseño

### 1. Observer / Event Emitter

**Problema que resuelve:** Define un mecanismo de suscripción que permite a objetos recibir notificaciones cuando otro objeto cambia de estado, habilitando comunicación uno a muchos sin dependencia directa.

**Donde se aplica:** En el sistema de notificaciones de la aplicación, actualizaciones de progreso en tiempo real, y el flujo de eventos entre la capa de servicios y los componentes de UI.

---

### 2. Builder

**Problema que resuelve:** Separa la construcción de objetos complejos de su representación final. Permite crear diferentes configuraciones de un mismo objeto sin constructores sobrecargados.

**Donde se aplica:** En la creación de simulacros ICFES (configurable por número de preguntas, tiempo, materias) y en la construcción de cursos offline con múltiples lecciones y recursos.

---

### 3. Singleton

**Problema que resuelve:** Garantiza que una clase tenga una única instancia global y proporciona un punto de acceso controlado a la misma, evitando múltiples instancias innecesarias.

**Donde se aplica:** En gestores que deben ser únicos: sesión de usuario activa, configuración de la aplicación, cache de contenido descargado, y el propio Event Bus central.

---

## Diagrama de Arquitectura (React Native + Expo)

```
[Frontend]
  React Native + Expo
   |
   v
[Event Bus]
   |
   v
[Servicios]
  - UserService (autenticación, perfil)
  - CourseService (catálogo de cursos)
  - QuizService (banco de preguntas)
  - ProgressService (seguimiento de avance)
  - GamificationService (logros, streaks)
  - SyncService (sincronización offline)
   |
   v
[Repository Layer]
  LocalRepository <---> RemoteRepository
   |
   v
[Data Sources]
  - Expo SQLite (cursos, preguntas, progreso)
  - AsyncStorage (configuración, preferencias)
  - FileSystem (contenido offline descargado)
```

---

## Selección Final

| Tipo | Selección |
|------|-----------|
| Estilo Arquitectónico | Capas (Layers) |
| Patrón Arquitectónico | Event-Driven |
| Patrón Arquitectónico | Presentation Layer |
| Patrón de Diseño | Observer / Event Emitter |
| Patrón de Diseño | Builder |
| Patrón de Diseño | Singleton |
