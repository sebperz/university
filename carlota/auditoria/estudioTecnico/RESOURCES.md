# Recursos de auditoría de IA en salud

## Knowledge

- [EU AI Act, Reglamento (UE) 2024/1689, texto oficial en español](https://eur-lex.europa.eu/legal-content/ES/TXT/?uri=CELEX:32024R1689)
  Fuente primaria para la clasificación de riesgo, el Anexo III, los artículos 10, 13, 14 y 15. Úsala para citar obligaciones con precisión. Verifica la versión vigente y las fechas de aplicación.
- [AI Act Explorer](https://artificialintelligenceact.eu/ai-act-explorer/)
  Texto navegable por artículo y anexo, con definiciones emergentes. Úsalo para leer rápido; contrasta siempre con el texto oficial.
- [NIST AI Risk Management Framework 1.0](https://www.nist.gov/itl/ai-risk-management-framework)
  Página oficial del marco. Úsala para las funciones Govern, Map, Measure y Manage. El documento completo está en [NIST.AI.100-1.pdf](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.100-1.pdf).
- [NIST AI RMF Playbook](https://airc.nist.gov/airmf-resources/playbook/)
  Acciones concretas asociadas a cada función del marco. Úsalo para convertir un hallazgo en una recomendación de auditoría.
- [XGBoost: Introduction to Boosted Trees](https://xgboost.readthedocs.io/en/stable/tutorials/model.html)
  Explicación oficial de los árboles de decisión potenciados y de la función objetivo. Úsala para entender qué hay detrás de un `XGBoost Classifier`.
- [SHAP documentation](https://shap.readthedocs.io/en/latest/)
  Documentación oficial de SHAP. Úsala para entender qué es un valor de Shapley, qué mide una explicación local y qué no mide.
- [scikit-learn: Metrics and scoring](https://scikit-learn.org/stable/modules/model_evaluation.html)
  Referencia para exactitud, precisión, recall, F1, ROC-AUC y matriz de confusión. Úsala para verificar fórmulas y definiciones.
- [Fairlearn](https://fairlearn.org/)
  Herramientas y guías para medir equidad y disparidad entre grupos. Úsala para pasar de "hay una brecha" a "esta es la métrica de equidad afectada".
- [Interpretable Machine Learning, Christoph Molnar](https://christophm.github.io/interpretable-ml-book/)
  Libro abierto sobre interpretabilidad, importancia de variables y explicaciones locales. Úsalo para entender los límites de SHAP.
- [WHO: Ethics and governance of artificial intelligence for health](https://www.who.int/publications/i/item/9789240029200)
  Guía de la OMS sobre ética y gobernanza de IA en salud. Úsala para el marco ético y para decidir qué daño cuenta como daño clínico.

## Wisdom (Communities)

- [Fairlearn Discord](https://discord.gg/R22yCfgsRn)
  Comunidad del proyecto Fairlearn. Úsala para preguntas de implementación sobre métricas de equidad y mitigación.
- [Cross Validated](https://stats.stackexchange.com/)
  Comunidad de estadística. Úsala para dudas sobre métricas, muestreo, intervalos de confianza y comparación entre grupos.
- [Stack Overflow: xgboost](https://stackoverflow.com/questions/tagged/xgboost)
  Úsala para dudas de implementación de XGBoost, no para decisiones de auditoría.
- [AI Incident Database](https://incidentdatabase.ai/)
  Base de incidentes reales de IA. Úsala para buscar casos comparables y entender cómo fallan los sistemas en producción.
- Comunidad local: grupo de estudio o semillero de auditoría de IA de tu universidad.
  Úsala para discutir el dictamen con otras personas. No se conoce un grupo específico todavía.

## Gaps

- Falta una fuente primaria sobre auditoría de IA en salud en Colombia. Buscar normativa local y guías del Ministerio de Salud en una sesión futura.
- Falta un caso real de triaje algorítmico con métricas desagregadas y matriz de confusión completa para comparar con el dossier.
