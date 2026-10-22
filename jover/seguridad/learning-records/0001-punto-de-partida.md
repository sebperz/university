# Punto de partida: DNS y correo desde cero

El estudiante declaró no saber qué es un registro DNS ni cómo funciona la autenticación de correo, y todavía no tiene dominio asignado para el Laboratorio 1. También declaró que el objetivo es aprender para uso propio, no solo aprobar una entrega.

Esto fija el punto de partida: cualquier lección que asuma SPF, DKIM o tipos de registro va a fallar. La secuencia debe empezar por consultas DNS y registro de dominios, con dominios públicos, y llegar a DMARC después. Las herramientas activas del laboratorio (Shodan, fuerza bruta de subdominios, FOCA descargando documentos) quedan para cuando exista autorización escrita.

## Evidence

Respuestas a la entrevista inicial del 2026-10-22: nivel "casi nada", sin dominio, objetivo "aprender para uso propio".

## Implications

- No usar dominios del laboratorio ni escaneos hasta que estén asignados y autorizados.
- Enseñar `dig`, `whois` y RDAP antes de DMARC.
- Tratar el RFC 9989 como fuente vigente, no el RFC 7489, que quedó obsoleto en mayo de 2026.
