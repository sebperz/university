# Simulacro 1: puntos débiles en tipos de compiladores y transpiladores

El usuario completó el simulacro de 25 preguntas (25–30 min) y reportó errores concentrados en **tipos de compiladores** (cruzado, JIT, nativo, incremental, una/varias pasadas, optimizador) y en **transpiladores e intérprete** (qué produce un transpilador, compilador vs. intérprete, compilación interna a bytecode). No reportó fallos en fases, análisis léxico/sintáctico/semántico ni estructuras de datos.

Esto importa porque el resto del temario parece asentado y la brecha está en la taxonomía de traductores, así que las próximas sesiones deben centrarse ahí y no re-enseñar las fases.

## Evidence
- El usuario seleccionó explícitamente "Tipos de compiladores" y "Transpiladores e intérprete" como los temas fallados.

## Implications
- La lección 03 se dedicó a estos dos temas, con la heurística "¿qué produce la salida?" (máquina → compilador; fuente de alto nivel → transpilador; nada → intérprete).
- Reforzar con un simulacro 2 centrado en esta taxonomía antes del examen.
- Vincular esta taxonomía con el mapa de fases (front/back-end) para evitar confusión: el back-end depende de la máquina, y de ahí nacen cruzado/nativo.
