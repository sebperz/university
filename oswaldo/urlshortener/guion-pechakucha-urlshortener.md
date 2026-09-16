# Guion PechaKucha 20x20 — Acortador de URLs ("Ruyi")

> Proyecto: Acortador de URLs con estadísticas de uso.
> Formato: 20 diapositivas × 20 segundos (6 min 40 s).
> Cada bloque de texto está calibrado para ~20 segundos de habla (50–60 palabras).

---

## Bloque 1: El Problema y el Contexto (Diapositivas 1–2)

### Diapositiva 1 — ¿Qué es Ruyi?
**Imagen sugerida:** mockup de la pantalla principal: campo de texto con un link largo y un botón "Acortar".

**Qué decir:**
"Hemos construido 'Ruyi', un acortador de URLs: el usuario ingresa a la página, pega un link largo y enorme, y el sistema le devuelve una versión corta y limpia. Pero además, cada vez que alguien abre ese link corto, nosotros registramos el uso, generando estadísticas valiosas de acceso."

### Diapositiva 2 — El "plano de la casa"
**Imagen sugerida:** plano esquemático del sistema: navegador → servidor → base de datos, con flechas de flujo.

**Qué decir:**
"Antes de programar, diseñamos el plano: la arquitectura de software. Igual que el plano de una casa define dónde van las tuberías, nuestro diseño define cómo se comunican los módulos de acortamiento, redirección y estadísticas. Esta separación temprana evita que el sistema se vuelva frágil cuando crezca."

---

## Bloque 2: El Rol del Arquitecto y Leyes (Diapositivas 3–5)

### Diapositiva 3 — Nuestra función como arquitectos
**Imagen sugerida:** ícono de puente entre "Negocio" y "Tecnología".

**Qué decir:**
"En este proyecto asumimos el rol de líderes técnicos y estrategas: somos el puente entre el negocio (medir el alcance de los links) y la tecnología (código robusto). Nuestra tarea fue tomar decisiones clave y gestionar riesgos, como anticipar cuellos de botella en la redirección, la operación más crítica del sistema."

### Diapositiva 4 — Ley de Tesler
**Imagen sugerida:** comparación "1 click para el usuario / 100 procesos internos".

**Qué decir:**
"Aplicamos la Ley de Tesler, la conservación de la complejidad: la complejidad no desaparece, solo se reubica. La redirección y el registro de estadísticas son procesos complejos, así que los trasladamos al backend. El usuario solo ve dos pantallas: pegar un link y pegar otro. Su experiencia es de un solo clic."

### Diapositiva 5 — Ley de Conway
**Imagen sugerida:** dos cajas de equipo: "Acortamiento/Redirección" y "Analítica".

**Qué decir:**
"La Ley de Conway dice que el software refleja la estructura de comunicación del equipo. Dividimos el grupo en dos: uno responsable del núcleo (acortar y redirigir) y otro de la analítica (estadísticas). Al alinear equipos con módulos, logramos que cada capa del sistema tuviera un dueño claro y coherencia interna."

---

## Bloque 3: Estilo Arquitectónico en Capas (Diapositivas 6–10)

### Diapositiva 6 — Vista general: Arquitectura en Capas
**Imagen sugerida:** diagrama de 4 capas apiladas: Presentación → Lógica → Persistencia → Base de Datos.

**Qué decir:**
"Elegimos el estilo de Arquitectura en Capas, organizando el sistema en niveles con responsabilidades únicas: Presentación, Lógica de Negocio, Persistencia y Base de Datos. Cada capa solo habla con la de abajo. Esta separación convierte un problema grande en cuatro problemas pequeños y manejables."

### Diapositiva 7 — Capa de Presentación
**Imagen sugerida:** wireframe de la web: input de link, botón acortar, pantalla de resultado con el link corto.

**Qué decir:**
"La capa de Presentación es el punto de entrada: la página web donde el usuario pega su link largo, recibe el link corto y desde donde se dispara la redirección instantánea. Es la única capa que ve el usuario; su regla es ser simple y ligera, delegando toda la inteligencia a las capas inferiores."

### Diapositiva 8 — Capa de Lógica de Negocio (Cerrada)
**Imagen sugerida:** caja "Reglas": generar código único, validar URL, resolver redirección.

**Qué decir:**
"Definimos la Lógica de Negocio como capa cerrada para las escrituras: toda petición que crea un link pasa por sus reglas — validar la URL, generar el código aleatorio de 6 caracteres y registrar el mapeo. Pero la redirección, la operación más frecuente, no vuelve a validar todo: consulta una caché que resuelve el código en microsegundos, y solo si falla baja a la base de datos."

### Diapositiva 9 — Capa de Servicios (Abierta) · Event Dispatcher
**Imagen sugerida:** capa transversal "Servicios: Estadísticas / Logging" cruzando las capas.

**Qué decir:**
"Incorporamos una capa abierta de servicios comunes, como el módulo de Estadísticas. Pero no la llamamos sincrónicamente: la redirección dispara un evento 'click registrado' a una cola y sigue su camino, sin esperar. Un consumidor lo procesa en segundo plano. Así desacoplamos la analítica de la redirección: registrar sin frenar, que es justamente lo que un acortador necesita."

### Diapositiva 10 — Capa de Persistencia y BD + Beneficios
**Imagen sugerida:** tabla de BD con dos entidades: links (corto, largo) y clicks (fecha, origen).

**Qué decir:**
"La Persistencia solo guarda y recupera, y la dividimos en dos: el store de mapeos (corto→largo) y el store de analítica (clicks), que se alimenta desde la cola. Gracias a la caché, la base de datos no se golpea en cada redirección. Un cambio de base de datos no impacta la interfaz, y podemos probar cada capa por separado."

---

## Bloque 4: Atributos de Calidad (Diapositivas 11–14)

### Diapositiva 11 — Rendimiento
**Imagen sugerida:** cronómetro marcando "< 100 ms" junto a un link redirigiendo.

**Qué decir:**
"Priorizamos el rendimiento: la redirección debe ser prácticamente instantánea, porque un usuario que clickea un link no tolera esperas. El código corto se resuelve en la caché, no en disco, logrando baja latencia en el lookup. Si la redirección tardara segundos, la herramienta perdería todo su valor: la velocidad ES el producto."

### Diapositiva 12 — Disponibilidad
**Imagen sugerida:** signo "99.9%" con un globo de internet siempre encendido.

**Qué decir:**
"El sistema debe estar accesible el 99.9% del tiempo. Cada minuto caído rompe millones de links en publicaciones, correos y campañas: una caída significa redirecciones muertas y confianza destruida. Por eso la disponibilidad es innegociable, sobre todo en picos cuando un link corto se vuelve viral."

### Diapositiva 13 — Escalabilidad
**Imagen sugerida:** gráfico de carga subiendo en vertical con servidores replicándose.

**Qué decir:**
"Diseñamos para escalar: un solo link viral puede multiplicar el tráfico de golpe. Separamos las rutas: los servidores que redirigen son ligeros y escalan rápido, la caché distribuida absorbe el pico de lecturas, y las escrituras de estadísticas van a una cola procesada en segundo plano, sin degradar las redirecciones."

### Diapositiva 14 — Seguridad
**Imagen sugerida:** escudo sobre una URL, con alerta de "link malicioso bloqueado".

**Qué decir:**
"La seguridad protege en dos frentes: validar las URLs entrantes contra phishing y malware —no basta con que sea una URL válida— y proteger las estadísticas, que exponen el comportamiento de los usuarios. Además, los códigos son aleatorios, no secuenciales, y todo el dominio corto va por HTTPS. Un acortador oculta el destino final, y esa opacidad exige controles que la compensen."

---

## Bloque 5: Trade-offs o Balances (Diapositivas 15–18)

### Diapositiva 15 — Rendimiento vs. Consistencia de estadísticas
**Imagen sugerida:** balanza: "Redirección instantánea" vs. "Contador exacto al segundo".

**Qué decir:**
"Sacrificamos consistencia inmediata de las estadísticas por rendimiento: la redirección ocurre primero y el click se registra en segundo plano, asincrónicamente. En un pico masivo, un contador puede tardar milisegundos en actualizarse. Aceptamos ese desfase mínimo para que jamás se sienta la grabación del dato."

### Diapositiva 16 — Simplicidad vs. Seguridad
**Imagen sugerida:** formulario de "un solo campo" con un candado pequeño al lado.

**Qué decir:**
"Permitimos acortar sin registro para maximizar la usabilidad (cualquiera, en dos segundos, obtiene su link), pero eso abre la puerta al abuso anónimo. Elegimos compensar con validación de URLs y límites de uso por IP, en lugar de obligar a crear cuentas: ganamos adopción al costo de más validación interna."

### Diapositiva 17 — Capas cerradas vs. Rendimiento
**Imagen sugerida:** stack de capas con una flecha directa "atajo" por la capa abierta de servicios.

**Qué decir:**
"Para lograr velocidad agregamos una caché distribuida y una cola de eventos: son componentes extra que monitorear. Aceptamos esa complejidad operativa a cambio de latencia mínima — un balance deliberado entre mantenibilidad y rendimiento. La disciplina de capas se conserva, pero el camino caliente no la paga."

### Diapositiva 18 — Documentación de decisiones
**Imagen sugerida:** tabla/matriz de trade-offs con columnas "Se ganó / Se perdió".

**Qué decir:**
"Todas estas decisiones quedaron registradas en nuestra matriz de trade-offs: qué se ganó y qué se perdió con la arquitectura elegida. Documentarlas nos permite justificar ante cualquier interesado por qué aceptamos estos balances, y reevaluarlos si el contexto del negocio cambia en el futuro."

---

## Bloque 6: Conclusiones (Diapositivas 19–20)

### Diapositiva 19 — Evaluación de la arquitectura
**Imagen sugerida:** checklist verde: "Rápido ✓ Disponible ✓ Escalable ✓ Medible ✓".

**Qué decir:**
"Concluimos que nuestra arquitectura es exitosa porque no solo 'funciona': cumple los atributos que definimos desde el inicio. Las redirecciones son rápidas, el sistema está disponible, escala ante la viralidad, es seguro y además produce estadísticas de valor. El plano que dibujamos al principio sostuvo cada una de esas metas."

### Diapositiva 20 — Reflexión final
**Imagen sugerida:** link corto flotando sobre un plano arquitectónico de fondo.

**Qué decir:**
"Aprendimos que ser arquitectos es elegir conscientemente qué problemas aceptamos: sacrificamos consistencia instantánea, friction de registro y algo de latencia por capas, todo a cambio de un producto rápido, confiable y medible. La arquitectura correcta no es la más compleja, es la que protege lo que al negocio le importa."

---

## Resumen de imagen sugerida por diapositiva

| # | Tema | Imagen sugerida |
|---|------|-----------------|
| 1 | Qué es Ruyi | Mockup pantalla principal |
| 2 | El plano | Diagrama de flujo del sistema |
| 3 | Rol del arquitecto | Puente negocio–tecnología |
| 4 | Ley de Tesler | 1 click usuario / complejidad interna |
| 5 | Ley de Conway | Equipos ↔ módulos |
| 6 | Arquitectura en capas | Stack de 4 capas |
| 7 | Capa Presentación | Wireframe de la web |
| 8 | Lógica (cerrada) | Caja de reglas de negocio |
| 9 | Servicios (abierta) | Capa transversal de estadísticas |
| 10 | Persistencia y BD | Tablas links y clicks |
| 11 | Rendimiento | Cronómetro < 100 ms |
| 12 | Disponibilidad | 99.9% uptime |
| 13 | Escalabilidad | Pico de tráfico viral |
| 14 | Seguridad | Escudo sobre URL |
| 15 | Trade-off stats | Balanza rendimiento/consistencia |
| 16 | Trade-off simple/seguro | Formulario de un campo + candado |
| 17 | Trade-off capas | Atajo por capa abierta |
| 18 | Documentación | Matriz se ganó / se perdió |
| 19 | Evaluación | Checklist de atributos cumplidos |
| 20 | Reflexión | Link corto sobre plano |
