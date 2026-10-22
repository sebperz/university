# Respuestas al cuestionario de pre-análisis

Sistema auditado: SaludPrioriza-AI v2.4  
Entidad: Red Hospitalaria San José  
Fase: pre-análisis individual  
Fecha: 22 de octubre de 2026

Las respuestas se basan en los documentos A, B y C. Las cifras de impacto se expresan por cada 1.000 pacientes con riesgo real.

---

## Pregunta 1. Sesgo de definición del proxy

> Explica detalladamente por qué definir el objetivo del modelo ($Y$) utilizando el proxy `Gasto_Salud_Futuro_Anual` introduce un sesgo sistémico discriminatorio en perjuicio de poblaciones de bajos ingresos o en régimen subsidiado.

El modelo dice predecir el riesgo de complicación a 30 días, pero aprende a predecir el gasto de los 12 meses siguientes. El gasto no mide necesidad clínica. Mide cobertura, capacidad de pago y facturación.

Dos pacientes con la misma edad, las mismas comorbilidades y la misma presión arterial pueden generar facturas muy distintas según su régimen. El paciente subsidiado enfrenta demoras, menor oferta de especialistas y barreras de acceso. Su gasto es menor aunque su riesgo sea igual o mayor. El proxy convierte esa diferencia de acceso en una diferencia de etiqueta.

El percentil 85 agrava el problema. El corte se calcula sobre una distribución común dominada por los pacientes de mayores ingresos. El 15% superior no es el 15% más enfermo: es el que más factura. Un paciente subsidiado con varias patologías puede estar en el decil más alto de su grupo y aun así quedar bajo el corte global. El modelo lo etiqueta como negativo y lo excluye del programa.

Hay un problema técnico adicional. `Gasto_Salud_Anual` mide el gasto de los últimos 12 meses y la variable objetivo mide el gasto de los 12 siguientes. El modelo aprende persistencia de facturación, no complicación. Eso explica el 42% de importancia SHAP y un AUC de 0,89 que puede verse alto. También puede estar capturando el costo de la complicación que quiere predecir, o el efecto del programa preventivo si ya operaba. Es un pronóstico financiero con etiqueta clínica.

La consecuencia es sistémica. Un paciente con riesgo alto y gasto bajo recibe un IRC-30 bajo, no entra al programa, se complica y regresa a urgencias. El 42% de falsos negativos del Grupo B es la misma historia vista desde la estadística. El sesgo está en la definición de $Y$, no en un hiperparámetro. Por eso es discriminatorio aunque el algoritmo no use raza o ingreso: la desigualdad entra por la etiqueta.

---

## Pregunta 2. Análisis de variables proxy e impacto estructural

> Al examinar los valores SHAP del Documento B, las variables `Gasto_Salud_Anual` (42%) y `Codigo_Postal` (18%) suman un 60% del peso en las decisiones del modelo. ¿Qué fenómenos de segregación socioeconómica o discriminación indirecta se están codificando a través de estas variables?

Los dos pesos suman 60%, pero el problema no es la suma. Ambas variables describen la posición socioeconómica del paciente, no su estado clínico.

`Gasto_Salud_Anual` es una variable administrativa. Mide facturación, no enfermedad. En un sistema mixto, el régimen contributivo se atiende en prestadores que facturan más por el mismo procedimiento. El modelo lee gasto alto como riesgo alto. También captura al prestador que ordena más pruebas o factura más. Es discriminación por proxy.

`Codigo_Postal` parece una variable neutra, pero ubica al paciente en un territorio con una historia de inversión, transporte y servicios. Puede reconstruir el ingreso y la composición étnica del barrio. El modelo no necesita saber la raza: la dirección se la dice. Es redlining algorítmico, una forma de discriminación indirecta que reproduce la segregación residencial. También codifica acceso: una zona con pocos especialistas puede gastar menos aunque esté más enferma.

`Tipo_Afiliación_Salud` aporta 5% directo, pero es redundante. El gasto y el código postal ya la reconstruyen, así que borrar la columna no elimina el sesgo. `Comorbilidades` aporta 20%, pero también está sesgada por el acceso: menos diagnósticos registrados pueden parecer menos enfermedad. `Edad` aporta 10% y puede amplificar el sesgo contra los adultos mayores que menciona la queja. `Visitas_Urgencias_Previas` pesa solo 2%, una señal de que el modelo prefiere variables administrativas.

Se codifica una cadena: residencia segregada, acceso, gasto, etiqueta y asignación del programa. El modelo refleja la segregación y, al asignar recursos, la refuerza. El SHAP global es un promedio y puede ocultar que en el Grupo B el gasto pesa todavía más. Hacen falta SHAP por subgrupo y análisis de interacciones.

Con 60% del peso en gasto y código postal, el modelo prioriza facturas y direcciones antes que necesidad clínica.

---

## Pregunta 3. Disparidad de impacto clínico (FNR)

> Compara la Tasa de Falsos Negativos (FNR) del Grupo A (11%) con la del Grupo B (42%). Transforma estas cifras a un análisis de impacto clínico real en el contexto de la atención médica de urgencias.

El FNR es la probabilidad de que el modelo diga "bajo riesgo" cuando el paciente sí tendrá una complicación. En un tamizaje, es el error que más daño hace porque la consecuencia es no actuar.

El Grupo A tiene un FNR de 11%; el Grupo B, de 42%. La diferencia es de 31 puntos porcentuales. El paciente del Grupo B tiene 3,82 veces más probabilidad de ser omitido. Por cada 1.000 pacientes con riesgo real, el modelo omite a 110 del Grupo A y a 420 del Grupo B. Son 310 pacientes por cada 1.000.

| Indicador | Grupo A | Grupo B |
|---|---|---|
| Sensibilidad (recall) | 89% | 58% |
| FNR | 11% | 42% |
| FPR | 8,5% | 12% |
| Omisiones por 1.000 pacientes con riesgo real | 110 | 420 |

En urgencias, el modelo se aplica en el punto de contacto. Si el puntaje es menor a 40, el paciente queda fuera del programa preventivo. Un falso negativo recibe el alta con etiqueta de bajo riesgo y sin seguimiento. Semanas después reingresa con una complicación grave, como reporta el Comité Ético-Clínico. La complicación pudo evitarse.

La sensibilidad protege al paciente; la precisión protege al sistema de falsas alarmas. Un modelo con 81% de precisión puede ser peligroso si deja pasar a 42 de cada 100 pacientes que necesitan ayuda. El Grupo B también tiene más FPR: 12% frente a 8,5%. Recibe más falsas alarmas y más omisiones. No hay compensación.

El impacto crece con el volumen. Si un servicio de urgencias egresa 1.000 pacientes de alto riesgo del Grupo B al mes, 420 quedan fuera del programa. El modelo diseñado para prever gasto termina produciendo el gasto de UCI que decía evitar.

La sensibilidad global de 82% no se puede reconciliar con el 58% del Grupo B sin la prevalencia y la matriz de confusión. Si ambos grupos tuvieran la misma prevalencia, el promedio ponderado por tamaño sería 76,6%, no 82%. El promedio global tapa la brecha. Con un FNR de 42%, el modelo no es un tamizaje seguro para el Grupo B: es un filtro que reproduce la desigualdad.

---

## Pregunta 4. Infracciones regulatorias normativas

> Identifica y argumenta al menos dos (2) violaciones explícitas al EU AI Act (especificando artículo) y una (1) falla dentro de las funciones del NIST AI RMF 1.0 en las que incurre la versión v2.4 del modelo.

El sistema es de alto riesgo por el Anexo III, categoría 5, porque prioriza el acceso a un servicio esencial de salud. Esa clasificación activa las obligaciones del Título III, capítulo 2.

### Artículo 10. Gobernanza de datos

El Artículo 10 exige datos pertinentes, representativos, completos y con examen y mitigación de sesgos. La v2.4 falla en los tres frentes. La variable objetivo mide gasto, no complicación. La etiqueta no representa la necesidad del régimen subsidiado. Y no hay análisis de sesgo por subgrupo. La brecha de 42% frente a 11% es la prueba.

### Artículo 13. Transparencia

El Artículo 13 exige transparencia e instrucciones para interpretar la salida. El clínico recibe un puntaje sin saber que el modelo optimiza gasto futuro, sin conocer la brecha de sensibilidad y sin una explicación local. El SHAP global es un promedio y no explica una decisión individual. Un tablero de importancia de variables no cumple la transparencia.

### Artículo 14. Supervisión humana

El Artículo 14 exige supervisión humana efectiva, con capacidad de entender, monitorear, anular o detener el sistema. Según la queja, el paciente con puntaje menor a 40 es rechazado y no se documenta una revisión médica. Es automatización sin human-in-the-loop. La supervisión no es un botón de aprobar: es la capacidad real de contradecir al modelo.

### NIST AI RMF 1.0: la falla está en Measure

La falla principal está en Measure. El marco pide medir exactitud, disparidad de sesgo, robustez y deriva. La v2.4 reporta solo métricas globales y un SHAP promedio. No hay métricas por subgrupo, calibración ni monitoreo de deriva. El reporte desagregado aparece después de la queja, no como parte del proceso. Sin esa medición, Govern no fija un límite, Map no identifica el riesgo y Manage no corrige.

El sistema se ve robusto en el promedio y falla en el subgrupo vulnerable. Por eso la v2.4 no debería desplegarse. Hay que redefinir la variable objetivo con un resultado clínico, eliminar los proxies socioeconómicos y geográficos, y añadir supervisión humana real antes de cualquier piloto.
