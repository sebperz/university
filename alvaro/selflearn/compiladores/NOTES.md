# Notas de trabajo

## Preferencias del usuario
- Idioma: **español** (términos técnicos en inglés cuando son estándar).
- Meta: examen de **Verdadero/Falso + opción múltiple** (formato ya confirmado).
- Base previa: casi nula en compiladores, autómatas y gramáticas.
- Pidió explícitamente "bastantes preguntas" → priorizar bancos de preguntas y drills interactivos.
- No se le han presentado comunidades todavía; no ha expresado rechazo.

## Plazo
- Examen en **1–3 días** (confirmado). Prioridad absoluta: práctica y trampas, no teoría extensa.
- Pidió un **simulacro completo** → creado `lessons/0002-simulacro-1.html` (25 preguntas, 30 min, nota y revisión).

## Progreso
- Hizo el simulacro 1. Puntos débiles: **tipos de compiladores** y **transpiladores/intérprete**. El resto, bien.
- Lección 03 creada para esos dos temas (`lessons/0003-traductores-y-tipos.html`) + chuleta `reference/0004-tipos-de-compiladores.html`.

## Decisiones
- Las lecciones serán cortas y cada una con un banco de preguntas interactivo.
- El motor de quiz (`assets/quiz.js`) debe soportar: V/F, opción única, opción múltiple y relacionar (matching), porque el examen usa las cuatro.
- Cuidado con la pregunta 10 del examen: la retroalimentación venía **con las respuestas invertidas** (un error de la plataforma). Enseñar el mapeo correcto: léxico → convertir caracteres en tokens; sintáctico → construir árbol; semántico → verificar tipos; optimización → mejorar eficiencia.
