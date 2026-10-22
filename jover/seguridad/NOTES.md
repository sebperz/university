# Notas de enseñanza

## Preferencias

- Idioma: español.
- Formato: lecciones cortas, con una habilidad concreta por lección.
- Estilo de escritura: sin guiones largos, frases cortas, ejemplos reales, fuentes enlazadas. Aplicar la skill `unslop`.
- Referencias imprimibles y con tablas.
- Nada de teoría sin un comando o una decisión que practicar.

## Contexto del estudiante

- Declaró nivel casi cero en DNS y correo (2026-10-22).
- Sin dominio asignado todavía. Práctica con dominios públicos y consultas pasivas.
- Objetivo doble: aprender para uso propio y llegar preparado al Laboratorio 1 de la diapositiva.
- Le interesan DMARC y las diez herramientas del laboratorio, no un temario completo de seguridad.

## Decisiones de diseño

- Lección 01 usa `wikipedia.org` porque sus registros son estables y públicos.
- Lección 02 usa `google.com`, `github.com` y `amazon.com` para mostrar políticas distintas y el caso de TXT partido.
- El lector de DMARC es reutilizable y vive en `assets/dmarc-decoder.js`.
- La referencia de herramientas separa pasivo, activo y zona gris. Es importante que no escanee nada sin autorización.
- FOCA se presenta como técnica vigente pero herramienta vieja. Alternativas: `exiftool` y `metagoofil`.

## Pendiente

- Lección 03: theHarvester pasivo y lectura de resultados.
- Lección 04: Shodan y Censys sobre un dominio autorizado.
- Lección 05: leer un informe agregado XML y convertirlo en decisiones.
- Cuando haya dominio asignado, actualizar la misión y el alcance.
