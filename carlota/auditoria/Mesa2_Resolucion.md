# Mesa 2. Explicabilidad, transparencia y gobernanza (XAI)

Sistema auditado: SaludPrioriza-AI v2.4  
Entidad: Red Hospitalaria San José  
Mesa: 2, Auditores de Explicabilidad, Transparencia y Gobernanza  
Fecha: 22 de octubre de 2026

La guía de la mesa pide "evaluar la interpretabilidad del modelo XGBoost, la validez de la atribución de importancia y los mecanismos de supervisión médica". La revisión se apoya en los documentos A, B y C del dossier. Las citas entre comillas son textuales.

---

## Matriz de hallazgos

| Dimensión evaluada | Hallazgo técnico detectado | Evidencia en Dossier | Métrica o criterio afectado | Propuesta de corrección |
|---|---|---|---|---|
| Atribución de importancia (SHAP) | El reporte ofrece importancia global promedio, no explicaciones locales ni por subgrupo. El 60% del peso está en gasto y código postal, variables socioeconómicas. El modelo es un conjunto de árboles, así que la atribución es posterior y no causal. | "Análisis de Explicabilidad Global (Valores Importancia SHAP Averaged)"; "Gasto_Salud_Anual" 42.0%; "Codigo_Postal" 18.0%; "Gradient Boosted Decision Trees (XGBoost Classifier v1.7.1)". | Validez de la atribución; Artículo 13; NIST Measure; NIST Map. | SHAP local por paciente, SHAP por subgrupo, análisis de interacciones y validación con clínicos. Documentar método, fondo y signo. Retirar o transformar los proxies. |
| Transparencia clínico-paciente | El clínico recibe un puntaje y un umbral, pero no la definición de la variable objetivo, las limitaciones, el desempeño por subgrupo ni una explicación local. El 82% global de sensibilidad oculta el 58% del Grupo B. El dossier no documenta una explicación para el paciente rechazado. | Artículo 13: "suficiente transparencia para permitir a los usuarios interpretar sus resultados"; "Recall Global: 82.0%"; Grupo B: "Recall (Sensibilidad)" 58.0%; queja: "rechazados por el sistema". | Artículo 13; NIST Measure; NIST Govern; confianza clínica. | Ficha de modelo y manual de uso con propósito, variable objetivo, umbral, métricas por subgrupo y limitaciones. Explicación local, guion de comunicación al paciente y canal de reclamación. |
| Mecanismo human-in-the-loop | No hay evidencia de revisión humana, anulación, botón de parada ni protocolo de escalamiento. El sistema rechaza con puntaje menor a 40. Sin explicación local, el clínico no tiene información para contradecir el puntaje. | Artículo 14: "mecanismos de interactividad que permitan a personas cualificadas supervisar de manera efectiva la herramienta"; queja: "rechazados por el sistema"; "reingresando semanas después por complicaciones graves en unidades de cuidados intensivos". | Artículo 14; NIST Govern; NIST Manage; tasa de anulación, tiempo de revisión y proporción de decisiones revisadas. | Revisión obligatoria de puntajes bajos, anulación documentada, botón de parada, escalamiento y auditoría de decisiones. Capacitación en sesgo de automatización y responsable nombrado. |

---

## 1. Atribución de importancia (SHAP)

### Hallazgo

El dossier presenta un análisis de explicabilidad global, no una explicación por paciente. La tabla muestra la importancia relativa promedio de cada variable. El gasto anual aporta 42.0% y el código postal 18.0%: juntos suman 60%. Las variables clínicas y demográficas suman 35%. El modelo se apoya más en la posición socioeconómica que en la clínica.

El peso del gasto es una parte del problema. La otra es que el modelo es un XGBoost, un conjunto de árboles que no es interpretable por diseño. La atribución SHAP es una reconstrucción posterior, no una descripción de cómo razona el modelo. Sin el método, el conjunto de fondo y el signo de los valores, la tabla no es reproducible. Tampoco hay SHAP por subgrupo, así que el promedio puede ocultar que en el Grupo B el gasto pesa todavía más.

### Evidencia directa

> "Análisis de Explicabilidad Global (Valores Importancia SHAP Averaged)"  
> (Documento B, sección de explicabilidad)

> "Gasto_Salud_Anual" 42.0%; "Comorbilidades" 20.0%; "Codigo_Postal" 18.0%; "Edad" 10.0%; "Tipo_Afiliación_Salud" 5.0%; "Presión_Arterial_Media" 3.0%; "Visitas_Urgencias_Previas" 2.0%.  
> (Documento B, tabla de importancia SHAP)

> "Gradient Boosted Decision Trees (XGBoost Classifier v1.7.1)."  
> (Documento A, ficha técnica, fila "Arquitectura de Algoritmo")

> "Riesgo_Complicación_Real: Definido operativamente mediante el proxy $Y_{proxy}$ = Gasto_Salud_Futuro_Anual (Percentil > 85 en los 12 meses posteriores al ingreso)."  
> (Documento A, ficha técnica, fila "Variable Objetivo")

### Lectura de auditoría

El reporte responde "qué variables pesan en promedio", no "por qué este paciente recibió 38/100". Esa diferencia es decisiva en un contexto clínico. Un clínico no puede discutir con un porcentaje global. Necesita saber qué factores empujaron el puntaje de su paciente y si esos factores son clínicos o administrativos.

La atribución también es válida solo para el modelo y la población con los que se calculó. Si el modelo se aplica a un grupo con otra distribución de gasto, la importancia puede cambiar. El dossier no muestra esa verificación. Tampoco muestra si el 42% corresponde a valores absolutos o con signo, ni si se usó TreeSHAP. Sin esos detalles, la tabla sirve como pista, no como prueba.

### Corrección

Entregar un anexo de explicabilidad con SHAP local para cada decisión, SHAP por subgrupo y análisis de interacciones. Documentar el método, el conjunto de fondo, el signo y la incertidumbre. Validar las explicaciones con clínicos que conozcan el caso. Retirar `Gasto_Salud_Anual` y `Codigo_Postal` o justificar su uso con una prueba de necesidad clínica. Mientras la variable objetivo siga siendo gasto, la explicación más honesta es decir que el modelo predice facturación.

---

## 2. Transparencia clínico-paciente

### Hallazgo

El Artículo 13 exige que el sistema sea transparente para que los usuarios interpreten la salida. El dossier reporta métricas globales y un SHAP promedio, pero no muestra instrucciones de uso, advertencias sobre el proxy, desempeño por subgrupo ni explicación local. El clínico ve un puntaje y un umbral, no el contexto que necesita para decidir.

La transparencia falla en dos niveles. Para el clínico, el 82% global de sensibilidad puede sonar aceptable, pero el Grupo B tiene 58%. Esa diferencia de 24 puntos no aparece en el resumen ejecutivo. Para el paciente, el dossier no documenta por qué fue rechazado, qué alternativas tiene ni cómo puede reclamar. Un puntaje menor a 40 se convierte en una decisión opaca.

### Evidencia directa

> "Obliga a que los sistemas funcionen con suficiente transparencia para permitir a los usuarios interpretar sus resultados y utilizarlos de manera adecuada."  
> (Documento C, Artículo 13)

> "Accuracy Global: 88.5%"; "ROC-AUC: 0.89"; "Precision Global: 84.0%"; "Recall Global: 82.0%"; "F1-Score Global: 0.83."  
> (Documento A, métricas globales)

> "Grupo B: Régimen Subsidiado / Ingreso Bajo / Minorías ... Recall (Sensibilidad) 58.0% ... FNR 42.0%."  
> (Documento B, métricas desagregadas)

> "Médicos de la Red de Hospitales Públicos reportan que pacientes adultos mayores pertenecientes a estratos socioeconómicos bajos y con múltiples patologías crónicas activas reciben sistemáticamente puntajes IRC-30 bajos (< 40/100). Debido a esto, son rechazados por el sistema para ingresar a los programas preventivos de alto valor, reingresando semanas después por complicaciones graves en unidades de cuidados intensivos."  
> (Documento B, queja del Comité Ético-Clínico)

### Lectura de auditoría

El reporte global no es neutral. Al mostrar 82% de sensibilidad sin la tabla por subgrupo, sugiere un desempeño que el Grupo B no tiene. El clínico que confía en el promedio puede dejar pasar a pacientes que el modelo no detecta. Esa es una falla de transparencia con consecuencia clínica.

La transparencia tampoco se resuelve con un tablero de importancia de variables. El clínico necesita saber qué mide el modelo, cuál es la variable objetivo real, cuál es el umbral, qué errores son más probables y qué hacer cuando el puntaje es bajo. El paciente necesita una explicación comprensible y un camino de revisión. El dossier no muestra ninguna de las dos cosas.

### Corrección

Publicar una ficha de modelo y un manual de uso clínico con propósito, variable objetivo, umbral, métricas globales y por subgrupo, limitaciones, riesgos conocidos y medidas de supervisión. Añadir una explicación local en lenguaje claro para cada decisión. Diseñar un guion de comunicación al paciente y un canal de reclamación. Entrenar al personal en el uso y en los límites del modelo. No mostrar un puntaje sin la advertencia de que el modelo predice gasto, no complicación.

---

## 3. Mecanismo human-in-the-loop

### Hallazgo

El Artículo 14 exige mecanismos para que personas cualificadas supervisen el sistema. El dossier describe un rechazo por el sistema de los pacientes con puntaje menor a 40 y no documenta revisión médica, anulación, botón de parada ni escalamiento. La queja del Comité Ético-Clínico confirma el resultado: los pacientes son rechazados y reingresan graves a UCI.

La supervisión humana no puede ser una firma al final del flujo. Para que sea efectiva, el clínico necesita información, tiempo, autoridad y un registro de su decisión. Aquí no hay explicación local, no hay tabla por subgrupo y no hay evidencia de que el clínico pueda contradecir el puntaje. Sin esas condiciones, el human-in-the-loop existe en el papel pero no en la práctica.

### Evidencia directa

> "Exige el diseño de mecanismos de interactividad que permitan a personas cualificadas supervisar de manera efectiva la herramienta (Human-in-the-loop / Human-on-the-loop)."  
> (Documento C, Artículo 14)

> "Debido a esto, son rechazados por el sistema para ingresar a los programas preventivos de alto valor, reingresando semanas después por complicaciones graves en unidades de cuidados intensivos."  
> (Documento B, queja del Comité Ético-Clínico)

> "pacientes adultos mayores ... reciben sistemáticamente puntajes IRC-30 bajos (< 40/100)."  
> (Documento B, queja del Comité Ético-Clínico)

### Lectura de auditoría

El sistema decide quién entra a un programa preventivo. También estima una probabilidad, pero la decisión de acceso es la que importa. Esa decisión tiene efecto directo sobre la salud. Dejar que un puntaje menor a 40 cierre la puerta sin revisión humana convierte al modelo en el decisor real. El clínico queda como testigo, no como supervisor.

La ausencia de explicación local agrava el problema. Si el clínico no sabe por qué el modelo dio 38, no puede evaluar si el puntaje es razonable. La supervisión se vuelve una aceptación ciega. El sesgo de automatización aparece justo ahí: el número parece objetivo y el clínico tiene poco tiempo para cuestionarlo.

### Corrección

Establecer revisión obligatoria por un clínico antes de excluir a un paciente del programa. Permitir anulación con justificación escrita y registrar la decisión. Añadir un botón de parada y un protocolo de escalamiento. Auditar una muestra de decisiones y medir la tasa de anulación, el tiempo de revisión y la proporción de casos revisados. Capacitar al personal en sesgo de automatización. Nombrar un responsable de la supervisión y documentar su autoridad.

---

## Cruce con el marco normativo y NIST

| Criterio | Qué exige el dossier | Qué muestra la v2.4 |
|---|---|---|
| Artículo 13 | Transparencia para interpretar la salida y usarla bien. | Métricas globales y SHAP promedio; sin explicación local ni desempeño por subgrupo. |
| Artículo 14 | Supervisión humana efectiva por personas cualificadas. | Rechazo por el sistema con puntaje menor a 40; sin revisión, anulación ni parada documentados. |
| NIST Measure | "Análisis cuantitativo y cualitativo de métricas de precisión, disparidad de sesgo, robustez y deriva (drift)." | Solo métricas globales y SHAP promedio; sin disparidad, calibración, robustez ni deriva. |
| NIST Govern | "Establecimiento de políticas de gobernanza, cultura organizacional e identificación de tolerancias al riesgo." | No se documenta una política de transparencia ni de supervisión humana. |
| NIST Map | "Contextualización del sistema, identificación de riesgos interdependientes de sesgo, privacidad y seguridad." | No se identifica el riesgo del proxy ni el flujo clínico de decisión. |
| NIST Manage | "Asignación de recursos para priorizar y mitigar los riesgos identificados de manera continua." | No hay plan de mitigación, reversión ni monitoreo continuo. |

La falla principal está en Measure. Sin medición desagregada, la organización no puede ver la brecha. Govern no fija un límite, Map no identifica el riesgo y Manage no corrige. La explicabilidad y la supervisión quedan como declaraciones, no como controles.

---

## Dictamen de la mesa

La Mesa 2 no aprueba el despliegue clínico de la versión 2.4 en su estado actual. El modelo puede predecir el gasto, pero no ofrece explicaciones locales, el reporte del modelo no declara su desempeño por subgrupo y no documenta un mecanismo verificable de supervisión humana. Sin esas tres piezas, el clínico no puede usar el puntaje de forma segura y el paciente no tiene un camino documentado para impugnar la decisión.

Las correcciones son condición para cualquier piloto: explicabilidad local y por subgrupo, ficha de modelo y manual de uso, revisión humana obligatoria con anulación y auditoría. La Mesa 2 debe coordinar con la Mesa 1 la redefinición de la variable objetivo y con la Mesa 4 el monitoreo de deriva y desempeño. Mientras la variable objetivo siga siendo gasto futuro, la explicación más honesta del sistema es que predice facturación, no riesgo clínico.

---

## Fuentes citadas

- Documento A: Ficha Técnica y Reporte del Modelo, filas "Propósito Intencionado", "Arquitectura de Algoritmo" y "Variable Objetivo"; métricas globales.
- Documento B: Reporte de Quejas y Métricas Desagregadas, queja del Comité Ético-Clínico, tabla de métricas por subgrupo y tabla de importancia SHAP.
- Documento C: Marco Normativo y Estándares de Referencia, artículos 13 y 14 del EU AI Act, y funciones Measure, Govern, Map y Manage del NIST AI RMF 1.0.
