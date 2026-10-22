# Mission: OSINT y DMARC para analizar un dominio

## Why
Estoy en un curso de seguridad con un laboratorio de reconocimiento OSINT y quiero entender qué hace cada herramienta, no copiar comandos. DMARC salió en el mismo contexto y quiero poder leer una política de correo y explicar qué protege y qué no.

## Success looks like
- Dado un dominio, obtener registro, DNS y política de correo con whois/RDAP y dig, sin tocar su infraestructura.
- Leer cualquier registro DMARC, explicar `p`, `sp`, `np`, alineación y `rua`, y predecir qué le pasa a un correo falsificado.
- Elegir la herramienta correcta del laboratorio según la pregunta, sabiendo si es pasiva o activa.
- Producir una ficha de una página con hallazgos, fuente y fecha de cada dato.
- Defender esas decisiones oralmente, sin leer la pantalla.

## Constraints
- Español.
- Nivel de partida casi cero en DNS y correo.
- Sin dominio asignado todavía. La práctica usa dominios públicos y solo consultas pasivas.
- Lecciones cortas, de 20 a 30 minutos, con referencias imprimibles.
- Presupuesto: herramientas gratuitas o con plan gratuito.

## Out of scope
- Escaneo activo, explotación o pentesting.
- Montar un servidor de correo propio.
- Criptografía de DKIM en profundidad.
- Asesoría legal sobre protección de datos.
