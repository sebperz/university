# Calidad de software (AP-REQ-AV-2026, Caso C) — Recursos

## Knowledge

- [ISO/IEC 25010 — OBP oficial (ISO.org)](https://www.iso.org/obp/ui/#iso:std:isoiec:25010:en)
  Fuente normativa obligatoria de la actividad. Use for: definiciones exactas de las 9 características y sus subcaracterísticas. (Nota: el OBP requiere navegador; la réplica autorizada de abajo es legible).
- [Portal oficial ISO/IEC 25000 — iso25000.com (EN)](https://iso25000.com/index.php/en/iso-25000-standards/iso-25010) · [versión en español](https://iso25000.com/index.php/es/normas-iso-25000/iso-25010)
  Réplica del contenido de la norma mantenida por el portal ISO/IEC 25000 (AENOR/UGC). Use for: texto completo de las 9 características de calidad de producto, incluidas Fiabilidad, Seguridad y Flexibilidad→Escalabilidad.
- [Quality Attribute Scenario — A way to define Software Quality Requirements (Anil Goyal, Medium)](https://medium.com/@anil.goyal0057/quality-attribute-scenario-a-way-to-define-software-quality-requirements-71dd82f4be1b)
  Lectura obligatoria de la actividad. Use for: la anatomía SEI de 6 partes (estímulo, fuente, entorno, artefacto, respuesta, medida de respuesta), resumida del libro *Software Architecture in Practice* (Bass, Clements, Kazman / SEI).
- [SEI — Software Architecture (Carnegie Mellon)](https://www.sei.cmu.edu/our-work/software-architecture/)
  Instituto que creó el patrón de escenarios de atributos y el ATAM®. Use for: respaldo primario de la terminología de escenarios; libros *Software Architecture in Practice* y *Designing Software Architectures*.
- [Martin Fowler — GivenWhenThen](https://martinfowler.com/bliki/GivenWhenThen.html)
  Lectura metodológica obligatoria. Use for: qué significa Given/When/Then (precondición / evento / resultado observable) y su equivalencia con Four-Phase Test (Arrange-Act-Assert).
- [Cucumber — Gherkin Reference](https://cucumber.io/docs/gherkin/reference/) · [Gherkin localizado (70+ idiomas, incluido español)](https://cucumber.io/docs/gherkin/languages)
  Referencia oficial del DSL. Use for: sintaxis exacta (`# language: es`, `Característica/Escenario/Dado/Cuando/Entonces`), Data Tables, Scenario Outline, reglas de Then observable.
- [AWS Architecture Blog — Master ADRs: Best Practices](https://aws.amazon.com/blogs/architecture/master-architecture-decision-records-adrs-best-practices-for-effective-decision-making/)
  Lectura obligatoria de ingeniería. Use for: 10 prácticas (una decisión por ADR, readout de 10-15 min, <10 participantes, decisiones de "two-way door", ADRs inmutables).
- [AWS Prescriptive Guidance — ADR process](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html) · [ejemplo completo (apéndice)](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/appendix.md)
  Plantilla formal: Título, Estado, Fecha, Contexto, Decisión, Consecuencias (positivas/negativas), Cumplimiento, Notas. Use for: esqueleto del Módulo 3.

## Wisdom (Communities)

- [Software Engineering Stack Exchange](https://softwareengineering.stackexchange.com/questions/tagged/architecture)
  Q&A moderado sobre arquitectura y requisitos de calidad. Use for: despejar dudas de especificación; ver cómo profesionales justifican trade-offs (CAP, consistencia).
- [r/softwarearchitecture](https://www.reddit.com/r/softwarearchitecture/)
  Comunidad activa de arquitectos. Use for: contrastar decisiones (ADR) reales y plantillas en producción.
- [Cucumber Community (Discord + foros)](https://cucumber.io/community/)
  Mantenedores y usuarios de Gherkin/BDD. Use for: dudas de sintaxis y prácticas de escenarios ejecutables.

## Gaps

- No existe fuente pública gratuita que reproduzca el texto normativo completo de ISO/IEC 25010:2023 (la norma es de pago). El portal iso25000.com es la mejor réplica fiable; citar la norma oficial en la entrega.
- Falta un ejemplo académico de ADR aplicado a logística georreferenciada: se trabajará con la plantilla AWS aplicada al Caso C.
