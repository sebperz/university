# DOSSIER DOCUMENTAL COMPLETO

**Sistema auditado:** SaludPrioriza-AI v2.4
**Entidad:** Red Hospitalaria San José (atención mixta, pública y privada)

---

## DOCUMENTO A: Ficha Técnica y Reporte del Modelo (SaludPrioriza-AI v2.4)

| Parámetro | Detalle Técnico |
|---|---|
| **Nombre del Sistema** | SaludPrioriza-AI (Versión 2.4 - Pre-producción) |
| **Propósito Intencionado** | Clasificar el Índice de Riesgo de Complicación a 30 días (IRC-30) en pacientes que ingresan a urgencias o consulta prioritaria para asignar ingresos a Programas de Manejo Preventivo Intensivo. |
| **Población Objetivo** | Pacientes adultos afiliados a la Red Hospitalaria San José (Atención mixta). |
| **Arquitectura de Algoritmo** | Gradient Boosted Decision Trees (XGBoost Classifier v1.7.1). |
| **Dataset de Entrenamiento** | 250,000 registros históricos anonimizados correspondientes al periodo 2018–2023. |
| **Variables de Entrada ($X$)** | • **Edad:** Años cumplidos.<br>• **Gasto_Salud_Anual:** Facturación acumulada en USD (últimos 12 meses).<br>• **Comorbilidades:** Número de patologías crónicas diagnosticadas.<br>• **Visitas_Urgencias_Previas:** Conteo de ingresos a urgencias en el último año.<br>• **Codigo_Postal:** Zonal geográfico de residencia.<br>• **Tipo_Afiliación_Salud:** Categoría de régimen (0 = Subsidiado/Público, 1 = Contributivo/Privado).<br>• **Presión_Arterial_Media:** Presión arterial sistólica/diastólica promedio registrada. |
| **Variable Objetivo ($Y$)** | **Riesgo_Complicación_Real:** Definido operativamente mediante el proxy $Y_{proxy}$ = Gasto_Salud_Futuro_Anual (Percentil > 85 en los 12 meses posteriores al ingreso). |

### Métricas Globales de Rendimiento (Dataset de Prueba Overall $n=50,000$)

1. Accuracy Global: **88.5%**
2. ROC-AUC: **0.89**
3. Precision Global: **84.0%**
4. Recall Global: **82.0%**
5. F1-Score Global: **0.83**

---

## DOCUMENTO B: Reporte de Quejas y Métricas Disagregadas

### Queja Presentada por el Comité Ético-Clínico

Médicos de la Red de Hospitales Públicos reportan que pacientes adultos mayores pertenecientes a estratos socioeconómicos bajos y con múltiples patologías crónicas activas reciben sistemáticamente puntajes IRC-30 bajos (< 40/100). Debido a esto, son rechazados por el sistema para ingresar a los programas preventivos de alto valor, reingresando semanas después por complicaciones graves en unidades de cuidados intensivos.

### Descomposición de Métricas por Subgrupo Socioeconómico/Régimen

| Subgrupo Epidemiológico / Socioeconómico | Tamaño Muestra ($n$) | Precision | Recall (Sensibilidad) | FNR (Tasa Falsos Negativos) | FPR (Tasa Falsos Positivos) |
|---|---|---|---|---|---|
| **Grupo A:** Régimen Privado / Ingreso Medio-Alto | 30,000 | 86.0% | 89.0% | 11.0% | 8.5% |
| **Grupo B:** Régimen Subsidiado / Ingreso Bajo / Minorías | 20,000 | 81.0% | 58.0% | 42.0% | 12.0% |

### Análisis de Explicabilidad Global (Valores Importancia SHAP Averaged)

| Variable ($X_i$) | Importancia SHAP Relativa (%) |
|---|---|
| Gasto_Salud_Anual | 42.0% |
| Comorbilidades | 20.0% |
| Codigo_Postal | 18.0% |
| Edad | 10.0% |
| Tipo_Afiliación_Salud | 5.0% |
| Presión_Arterial_Media | 3.0% |
| Visitas_Urgencias_Previas | 2.0% |

---

## DOCUMENTO C: Marco Normativo y Estándares de Referencia

### 1. EU AI Act (Reglamento de Inteligencia Artificial de la Unión Europea)

1. **Clasificación de Riesgo:** Sistemas de IA utilizados para priorización o asignación de acceso a servicios esenciales de salud están clasificados como **Sistemas de Alto Riesgo** (Anexo III, Categ. 5).
2. **Artículo 10 (Gobernanza de Datos):** Exige que los conjuntos de datos de entrenamiento y prueba sean pertinentes, representativos y, en la medida de lo posible, libres de errores y completos, considerando los sesgos específicos del contexto.
3. **Artículo 13 (Transparencia):** Obliga a que los sistemas funcionen con suficiente transparencia para permitir a los usuarios interpretar sus resultados y utilizarlos de manera adecuada.
4. **Artículo 14 (Supervisión Humana):** Exige el diseño de mecanismos de interactividad que permitan a personas cualificadas supervisar de manera efectiva la herramienta (Human-in-the-loop / Human-on-the-loop).

### 2. NIST AI Risk Management Framework (AI RMF 1.0)

1. **Govern (Gobernar):** Establecimiento de políticas de gobernanza, cultura organizacional e identificación de tolerancias al riesgo.
2. **Map (Mapear):** Contextualización del sistema, identificación de riesgos interdependientes de sesgo, privacidad y seguridad.
3. **Measure (Medir):** Análisis cuantitativo y cualitativo de métricas de precisión, disparidad de sesgo, robustez y deriva (drift).
4. **Manage (Gestionar):** Asignación de recursos para priorizar y mitigar los riesgos identificados de manera continua.
