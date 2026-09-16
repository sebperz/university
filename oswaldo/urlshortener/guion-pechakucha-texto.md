# Guion PechaKucha 20x20 — Texto a decir

## Diapositiva 1
Hemos construido 'Ruyi', un acortador de URLs: el usuario ingresa a la página, pega un link largo y enorme, y el sistema le devuelve una versión corta y limpia. Pero además, cada vez que alguien abre ese link corto, nosotros registramos el uso, generando estadísticas valiosas de acceso.

## Diapositiva 2
Antes de programar, diseñamos el plano: la arquitectura de software. Igual que el plano de una casa define dónde van las tuberías, nuestro diseño define cómo se comunican los módulos de acortamiento, redirección y estadísticas. Esta separación temprana evita que el sistema se vuelva frágil cuando crezca.

## Diapositiva 3
En este proyecto asumimos el rol de líderes técnicos y estrategas: somos el puente entre el negocio (medir el alcance de los links) y la tecnología (código robusto). Nuestra tarea fue tomar decisiones clave y gestionar riesgos, como anticipar cuellos de botella en la redirección, la operación más crítica del sistema.

## Diapositiva 4
Aplicamos la Ley de Tesler, la conservación de la complejidad: la complejidad no desaparece, solo se reubica. La redirección y el registro de estadísticas son procesos complejos, así que los trasladamos al backend. El usuario solo ve dos pantallas: pegar un link y pegar otro. Su experiencia es de un solo clic.

## Diapositiva 5
La Ley de Conway dice que el software refleja la estructura de comunicación del equipo. Dividimos el grupo en dos: uno responsable del núcleo (acortar y redirigir) y otro de la analítica (estadísticas). Al alinear equipos con módulos, logramos que cada capa del sistema tuviera un dueño claro y coherencia interna.

## Diapositiva 6
Elegimos el estilo de Arquitectura en Capas, organizando el sistema en niveles con responsabilidades únicas: Presentación, Lógica de Negocio, Persistencia y Base de Datos. Cada capa solo habla con la de abajo. Esta separación convierte un problema grande en cuatro problemas pequeños y manejables.

## Diapositiva 7
La capa de Presentación es el punto de entrada: la página web donde el usuario pega su link largo, recibe el link corto y desde donde se dispara la redirección instantánea. Es la única capa que ve el usuario; su regla es ser simple y ligera, delegando toda la inteligencia a las capas inferiores.

## Diapositiva 8
Definimos la Lógica de Negocio como capa cerrada para las escrituras: toda petición que crea un link pasa por sus reglas — validar la URL, generar el código aleatorio de 6 caracteres y registrar el mapeo. Pero la redirección, la operación más frecuente, no vuelve a validar todo: consulta una caché que resuelve el código en microsegundos, y solo si falla baja a la base de datos.

## Diapositiva 9
Incorporamos una capa abierta de servicios comunes, como el módulo de Estadísticas. Pero no la llamamos sincrónicamente: la redirección dispara un evento 'click registrado' a una cola y sigue su camino, sin esperar. Un consumidor lo procesa en segundo plano. Así desacoplamos la analítica de la redirección: registrar sin frenar, que es justamente lo que un acortador necesita.

## Diapositiva 10
La Persistencia solo guarda y recupera, y la dividimos en dos: el store de mapeos (corto→largo) y el store de analítica (clicks), que se alimenta desde la cola. Gracias a la caché, la base de datos no se golpea en cada redirección. Un cambio de base de datos no impacta la interfaz, y podemos probar cada capa por separado.

## Diapositiva 11
Priorizamos el rendimiento: la redirección debe ser prácticamente instantánea, porque un usuario que clickea un link no tolera esperas. El código corto se resuelve en la caché, no en disco, logrando baja latencia en el lookup. Si la redirección tardara segundos, la herramienta perdería todo su valor: la velocidad ES el producto.

## Diapositiva 12
El sistema debe estar accesible el 99.9% del tiempo. Cada minuto caído rompe millones de links en publicaciones, correos y campañas: una caída significa redirecciones muertas y confianza destruida. Por eso la disponibilidad es innegociable, sobre todo en picos cuando un link corto se vuelve viral.

## Diapositiva 13
Diseñamos para escalar: un solo link viral puede multiplicar el tráfico de golpe. Separamos las rutas: los servidores que redirigen son ligeros y escalan rápido, la caché distribuida absorbe el pico de lecturas, y las escrituras de estadísticas van a una cola procesada en segundo plano, sin degradar las redirecciones.

## Diapositiva 14
La seguridad protege en dos frentes: validar las URLs entrantes contra phishing y malware —no basta con que sea una URL válida— y proteger las estadísticas, que exponen el comportamiento de los usuarios. Además, los códigos son aleatorios, no secuenciales, y todo el dominio corto va por HTTPS. Un acortador oculta el destino final, y esa opacidad exige controles que la compensen.

## Diapositiva 15
Sacrificamos consistencia inmediata de las estadísticas por rendimiento: la redirección ocurre primero y el click se registra en segundo plano, asincrónicamente. En un pico masivo, un contador puede tardar milisegundos en actualizarse. Aceptamos ese desfase mínimo para que jamás se sienta la grabación del dato.

## Diapositiva 16
Permitimos acortar sin registro para maximizar la usabilidad (cualquiera, en dos segundos, obtiene su link), pero eso abre la puerta al abuso anónimo. Elegimos compensar con validación de URLs y límites de uso por IP, en lugar de obligar a crear cuentas: ganamos adopción al costo de más validación interna.

## Diapositiva 17
Para lograr velocidad agregamos una caché distribuida y una cola de eventos: son componentes extra que monitorear. Aceptamos esa complejidad operativa a cambio de latencia mínima — un balance deliberado entre mantenibilidad y rendimiento. La disciplina de capas se conserva, pero el camino caliente no la paga.

## Diapositiva 18
Todas estas decisiones quedaron registradas en nuestra matriz de trade-offs: qué se ganó y qué se perdió con la arquitectura elegida. Documentarlas nos permite justificar ante cualquier interesado por qué aceptamos estos balances, y reevaluarlos si el contexto del negocio cambia en el futuro.

## Diapositiva 19
Concluimos que nuestra arquitectura es exitosa porque no solo 'funciona': cumple los atributos que definimos desde el inicio. Las redirecciones son rápidas, el sistema está disponible, escala ante la viralidad, es seguro y además produce estadísticas de valor. El plano que dibujamos al principio sostuvo cada una de esas metas.

## Diapositiva 20
Aprendimos que ser arquitectos es elegir conscientemente qué problemas aceptamos: sacrificamos consistencia instantánea, friction de registro y algo de latencia por capas, todo a cambio de un producto rápido, confiable y medible. La arquitectura correcta no es la más compleja, es la que protege lo que al negocio le importa.
