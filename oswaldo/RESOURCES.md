# Fundamentos de Arquitectura de Software — Recursos

Material base del curso: `videos.pdf` (guía compilada de 6 videos de Codmind, agosto 2026).
Todo lo que se enseña en las lecciones se apoya en las fuentes verificadas de abajo, no en memoria paramétrica.

## Knowledge

- [Libro: _Software Architecture in Practice_ (4.ª ed.) — Bass, Clements y Kazman (SEI Series, Addison-Wesley)](https://www.oreilly.com/library/view/software-architecture-in/9780136885979)
  El texto de referencia del SEI/CMU. Fuente de la definición canónica de arquitectura y de la teoría de estructuras. La cita del PDF corresponde a la 2.ª edición; la 4.ª dice "the set of structures needed to reason about the system". Usar para: definiciones, atributos de calidad, patrones.
- [Libro: _Fundamentals of Software Architecture_ — Mark Richards y Neal Ford (O'Reilly)](https://www.oreilly.com/library/view/fundamentals-of-software/9781492043447)
  Fuente del análisis de capas: capas cerradas/abiertas, "layers of isolation", el anti-patrón sinkhole y las leyes de la arquitectura ("todo en arquitectura es un trade-off"). Usar para: capas, trade-offs, rating de estilos.
- [Paper: _An Introduction to Software Architecture_ — Garlan y Shaw (CMU/SEI-94-TR-021, 1994)](https://www.sei.cmu.edu/library/an-introduction-to-software-architecture)
  El texto fundacional. La cita del PDF ("más allá de los algoritmos y estructuras de datos… un nuevo tipo de problema") es verificada y textual. [PDF directo](https://www.sei.cmu.edu/documents/1119/1994_005_001_16331.pdf). Usar para: definiciones.
- [SEI de CMU: colección oficial de definiciones de arquitectura](https://www.sei.cmu.edu/architecture)
  Recopilación científica de definiciones de múltiples autores; confirma que no existe criterio único (afirmación del Video 3). Usar para: la discusión de definiciones.
- [Artículo: "How Do Committees Invent?" — Melvin Conway (Datamation, 1968)](https://www.melconway.com/Home/Committees_Paper.html)
  Fuente primaria de la Ley de Conway, con la cita textual verificada. [PDF original](http://www.melconway.com/Home/pdf/committees.pdf). Usar para: Ley de Conway.
- [RFC 793: Transmission Control Protocol — Jon Postel (IETF, 1981)](https://www.rfc-editor.org/info/rfc793)
  Fuente primaria de la Ley de Postel / Principio de Robustez: "be conservative in what you do, be liberal in what you accept from others". Usar para: Ley de Postel.
- [Eric Allman: "The Robustness Principle Reconsidered" (CACM, 2011)](https://cacm.acm.org/practice/the-robustness-principle-reconsidered)
  La crítica moderna a la Ley de Postel: ser demasiado tolerante con la entrada puede abrir huecos de seguridad. Matiz importante para el examen. Usar para: matices de Postel.
- [Larry Tesler: The Law of Conservation of Complexity (sitio oficial)](https://www.nomodes.com/larry-tesler-consulting/complexity-law)
  Formulación original de Tesler (~1984): "Every application has an inherent amount of irreducible complexity. The only question is: Who will have to deal with it?". Usar para: Ley de Tesler.
- [Ley de Tesler en español — Laws of UX (Jon Yablonski)](https://lawsofux.com/es/ley-de-tesler/)
  Explicación clara en español con el contexto histórico (Xerox PARC). Usar para: repaso rápido de Tesler.
- [Estándar: ISO/IEC 25010:2023 — Modelo de calidad de producto](https://www.iso.org/standard/78176.html)
  El estándar internacional de atributos de calidad (9 características: adecuación funcional, eficiencia de rendimiento, compatibilidad, capacidad de interacción, fiabilidad, seguridad, mantenibilidad, flexibilidad, seguridad-inocuidad). Usar para: anclar la clasificación del material en un estándar.
- [Martin Fowler: Conway's Law (bliki)](https://martinfowler.com/bliki/ConwaysLaw.html)
  Análisis moderno y práctico de la Ley de Conway por uno de los autores más citados. Usar para: implicaciones de Conway.
- [Blog de Codmind: Arquitectura en Capas (fragmento del libro _Introducción a la arquitectura de software_)](https://reactiveprogramming.io/blog/es/estilos-arquitectonicos/capas)
  El libro/curso de Codmind del cual provienen los videos. Fuente del material del curso (capas, definición integradora). Usar para: alinear el vocabulario exacto del examen.

## Wisdom (Communities)

- [r/SoftwareArchitecture](https://www.reddit.com/r/SoftwareArchitecture/)
  Comunidad activa de arquitectos y desarrolladores. Usar para: contrastar opiniones sobre trade-offs y estilos, resolver dudas reales.
- [Stack Overflow — etiqueta `software-architecture`](https://stackoverflow.com/questions/tagged/software-architecture)
  Preguntas concretas con respuestas votadas por pares. Usar para: dudas técnicas puntuales.
- [Software Engineering Stack Exchange](https://softwareengineering.stackexchange.com/)
  Discusiones conceptuales (diseño vs. arquitectura, rol del arquitecto). Usar para: profundizar conceptos con matices.
- [IASA Global](https://iasaglobal.org/)
  Asociación internacional de arquitectos de software/TI; publica guías de competencias del rol. Usar para: el rol profesional del arquitecto.

## Gaps
- Ninguno crítico. Si el examen incluye estilos adicionales (microkernel, event-driven), añadir capítulos correspondientes de Richards & Ford.
