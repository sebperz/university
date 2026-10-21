# RESOLUCIÓN DEL CUESTIONARIO DE PRE-ANÁLISIS

**Sistema auditado:** SaludPrioriza-AI v2.4
**Base documental:** Documentos A, B y C del dossier
**Carácter:** Análisis individual previo a la Sesión 1

---

## Pregunta 1. Sesgo de definición del proxy

El modelo no predice complicaciones: predice gasto. La etiqueta binaria se construye como

$$Y_{proxy} = \mathbb{1}\left[\,Gasto\_Salud\_Futuro\_Anual > P_{85}\,\right]$$

mientras que el fenómeno que se desea estimar es

$$Y = \mathbb{1}\left[\,\text{complicación severa a 30 días}\,\right].$$

Toda la auditoría de equidad depende de que $Y_{proxy} \approx Y$. En este caso no lo es, y el error no es aleatorio: está correlacionado con el régimen de afiliación y el nivel de ingreso.

### 1.1 El gasto mide consumo, no necesidad clínica

El gasto sanitario se descompone, para un paciente $i$, en:

$$Gasto_i \approx Necesidad_i \times Acceso_i \times Precio_i$$

- **Necesidad:** gravedad clínica real y carga de enfermedad.
- **Acceso:** probabilidad de que el paciente llegue al sistema, sea diagnosticado, reciba procedimientos y vuelva a consultar.
- **Precio:** tarifa facturada por el mismo acto médico según el régimen y el prestador.

El Grupo B (subsidiado, ingreso bajo, minorías) tiene, para una necesidad clínica igual o mayor, un **acceso sistemáticamente menor** (barreras geográficas, copagos, pérdida de ingresos por ausentarse, menor densidad de especialistas, subdiagnóstico) y un **precio facturado menor** (tarifas públicas frente a privadas). Por tanto:

$$Necesidad_B = Necesidad_A \;\Rightarrow\; Gasto_B < Gasto_A \;\Rightarrow\; P(Y_{proxy}=1 \mid B) < P(Y_{proxy}=1 \mid A)$$

El modelo aprende exactamente esa desigualdad y la reproduce como si fuera riesgo clínico. Un paciente pobre con necesidad alta recibe un score bajo no porque esté sano, sino porque **el sistema no registra su enfermedad en forma de factura**.

### 1.2 Consecuencia: sesgo de etiqueta y de constructo

Es un caso de **sesgo de etiqueta** (*label bias*) y de fallo de **validez de constructo**: el constructo medido (capacidad de generar gasto) sustituye al constructo objetivo (gravedad clínica). El sesgo es sistémico, no ruido:

1. **Dirección predecible:** siempre subestima al Grupo B y sobreestima al Grupo A.
2. **Magnitud no trivial:** el umbral $P_{85}$ es relativo a la población. El 15% superior de gasto está ocupado por pacientes de alto acceso y alto precio, no por los de mayor gravedad.
3. **Invisibilidad estadística:** como el grupo discriminado genera menos datos, el sesgo no aparece en métricas globales. Accuracy 88.5% y AUC 0.89 pueden coexistir con un FNR de 42% en el Grupo B.

### 1.3 Circularidad entre predictor y etiqueta

El predictor más importante es `Gasto_Salud_Anual` (42%), es decir, el **gasto pasado**. La etiqueta es el **gasto futuro**. El modelo está aprendiendo principalmente **persistencia de gasto**, no fisiología:

$$Gasto_{t+1} \approx f(Gasto_t, \text{régimen}, \text{zona})$$

Eso explica el AUC alto sin que exista capacidad predictiva clínica. Un modelo que detectara complicaciones reales debería apoyarse en variables fisiológicas y de comorbilidad, que en conjunto solo suman 35% del peso SHAP, y aun así `Comorbilidades` depende de la intensidad diagnóstica (a más acceso, más diagnósticos registrados).

### 1.4 Bucle de retroalimentación

La decisión del modelo altera los datos futuros:

- Paciente con score bajo → no ingresa al programa preventivo → se complica → reingresa por urgencias.
- En el Grupo A, esa complicación se factura y **refuerza** la etiqueta de alto riesgo.
- En el Grupo B, la complicación puede no facturarse o resolverse fuera de la red, de modo que **el daño no se contabiliza** y el sesgo se perpetúa.

El sistema no solo mide la inequidad histórica: la produce hacia adelante. Es el mismo mecanismo documentado por Obermeyer et al. (2019) en algoritmos que usaban costo como proxy de necesidad sanitaria.

### 1.5 Corrección exigible

La etiqueta debe redefinirse sobre un desenlace clínico verificable (complicación severa, ingreso a UCI, reingreso no programado, mortalidad a 30 días, deterioro funcional), construido con datos clínicos y no con facturación. Si se conserva el costo como variable auxiliar, debe entrar como *feature* y nunca como *target*.

---

## Pregunta 2. Variables proxy e impacto estructural

`Gasto_Salud_Anual` (42%) y `Codigo_Postal` (18%) concentran el 60% de la importancia SHAP. Sumando `Tipo_Afiliación_Salud` (5%), **el 65% del peso del modelo es señal socioeconómica**, no clínica.

### 2.1 `Gasto_Salud_Anual`: codifica capacidad de pago y acceso

La variable no mide cuánto se enferma una persona, sino cuánto puede consumir y cuánto se le factura. Codifica:

- **Capacidad económica:** quien puede pagar copagos y consultas privadas acumula más facturación.
- **Generosidad del aseguramiento:** el régimen contributivo factura tarifas más altas por actos equivalentes.
- **Intensidad de uso:** más especialistas, más imágenes, más procedimientos, no necesariamente más gravedad.
- **Acceso diferencial:** el paciente subsidiado posterga la consulta hasta la urgencia, donde el registro es episódico y de menor costo acumulado.

Al ser además el predictor dominante de un target construido con el mismo constructo, produce una **doble distorsión**: sesgo de etiqueta (Q1) y circularidad predictiva. El modelo aprende "quién gasta", que es casi lo mismo que "quién tiene acceso".

### 2.2 `Codigo_Postal`: codifica segregación residencial

El código postal no es una variable geográfica neutra. En una red hospitalaria mixta funciona como un **compuesto de estratificación social**:

| Fenómeno codificado | Mecanismo |
|---|---|
| **Segregación residencial** | La zona de residencia resume ingreso, nivel educativo y composición étnica del barrio. |
| **Redlining histórico** | Barrios excluidos de crédito y de inversión sanitaria concentran menor oferta de atención. |
| **Efecto vecindario** | Contaminación, vivienda, alimentación y violencia afectan la salud de forma desigual. |
| **Distancia y tiempo de traslado** | Zonas periféricas llegan más tarde y en peor estado; el registro clínico es más tardío. |
| **Oferta de especialistas** | Menor densidad de atención ambulatoria en zonas pobres. |

El modelo no necesita la raza ni el ingreso para discriminarlos: el código postal **los reconstruye** con altísima fidelidad. Es **discriminación indirecta por proxy** (*proxy discrimination*) y, en la práctica, **redlining algorítmico**: se asignan menos recursos preventivos a los territorios históricamente desatendidos, lo que profundiza la desatención.

### 2.3 Interacción entre proxies

Los proxies se refuerzan entre sí:

- `Gasto` y `Código_Postal` están correlacionados: las zonas pobres tienen menor gasto histórico.
- `Tipo_Afiliación` etiqueta el régimen de forma casi explícita (subsidiado/contributivo).
- `Comorbilidades` parece clínica, pero su conteo depende de cuántos diagnósticos se hayan podido registrar: a menor acceso, menos comorbilidades contabilizadas.

El resultado es un modelo que estima **riesgo de exclusión**, no riesgo clínico. La consecuencia estructural es una **asignación inversa de recursos**: quienes más necesitan el programa preventivo reciben el score más bajo.

### 2.4 Límites de la evidencia SHAP

Los porcentajes son promedios globales y deben interpretarse con cautela:

- **Importancia ≠ causalidad.** Un SHAP alto indica uso intensivo de la variable, no relación causal con la complicación.
- **Reparto entre proxies correlacionados.** Si dos variables miden lo mismo, SHAP divide su peso; el 60% es probablemente una **subestimación** del peso socioeconómico real.
- **Oculta heterogeneidad.** El promedio global puede esconder que, en el Grupo B, el código postal pese mucho más que en el Grupo A.
- **Suma 100% por construcción.** No informa sobre la calidad del modelo, solo sobre el reparto interno de su atención.

### 2.5 Corrección exigible

Eliminar `Código_Postal` y `Tipo_Afiliación` del conjunto de features; sustituir `Gasto` por variables clínicas y de utilización justificada clínicamente; auditar el poder predictivo residual de la zona mediante pruebas de equidad; documentar el análisis de proxies conforme al Art. 10 del EU AI Act.

---

## Pregunta 3. Disparidad de impacto clínico (FNR)

### 3.1 Lectura directa de las cifras

| Métrica | Grupo A (privado) | Grupo B (subsidiado) | Brecha |
|---|---|---|---|
| Recall / sensibilidad | 89.0% | 58.0% | −31.0 pp |
| **FNR** | **11.0%** | **42.0%** | **+31.0 pp** |
| FPR | 8.5% | 12.0% | +3.5 pp |
| Precision | 86.0% | 81.0% | −5.0 pp |
| $n$ | 30,000 | 20,000 | — |

El FNR del Grupo B es **3.82 veces** el del Grupo A. Por cada 100 pacientes que efectivamente desarrollarán una complicación severa:

- **11 del Grupo A** no son detectados.
- **42 del Grupo B** no son detectados.

Dicho de otro modo: el modelo identifica a 89 de cada 100 pacientes de alto riesgo en el Grupo A y solo a 58 de cada 100 en el Grupo B.

### 3.2 No es un problema de umbral: es un problema de ranking

Un ajuste de umbral que suba el recall del Grupo B también subiría su FPR. Pero aquí el Grupo B ya tiene **peor recall y peor FPR simultáneamente** (58%/12% frente a 89%/8.5%). Si solo fuera un umbral más exigente, un FPR mayor vendría acompañado de un recall mayor. Al ocurrir lo contrario, la capacidad de discriminación del modelo dentro del Grupo B está degradada: la distribución de scores separa peor a sanos de enfermos. **Ningún umbral único corrige esto**; se requiere reentrenamiento o recalibración por subgrupo.

Además, la precision del Grupo B (81%) es menor con un recall mucho menor, lo que confirma que el modelo es a la vez **más conservador y menos certero** en ese grupo.

### 3.3 Traducción a impacto clínico

El FNR no es una métrica abstracta: cada falso negativo es un paciente que **no entra al Programa de Manejo Preventivo Intensivo** y vuelve semanas después con una complicación grave. En urgencias, el circuito es:

1. Paciente llega a urgencias o consulta prioritaria.
2. El modelo calcula IRC-30 y asigna un score < 40/100.
3. El paciente es **rechazado** del programa preventivo de alto valor.
4. No hay seguimiento estrecho ni intervención temprana.
5. Reingreso por complicación severa, con frecuencia en UCI.
6. Mayor mortalidad, secuelas y costo catastrófico.

**Cuantificación por cada 1,000 pacientes evaluados** (escenario conservador: prevalencia real de 15% en ambos grupos):

| | Grupo A | Grupo B |
|---|---|---|
| Pacientes de alto riesgo real | 150 | 150 |
| Falsos negativos | **16.5** | **63.0** |
| Detectados correctamente | 133.5 | 87.0 |

El Grupo B pierde **46.5 casos prevenibles más por cada 1,000** pacientes, con una población total menor. Si se usan los tamaños del dossier y una prevalencia igual de 15%:

- Grupo A: 4,500 positivos reales → **495 no detectados**.
- Grupo B: 3,000 positivos reales → **1,260 no detectados**.

Es decir, **2.55 veces más complicaciones no prevenidas en un grupo que tiene 33% menos pacientes**.

El escenario es conservador. La queja del Comité Ético-Clínico describe precisamente adultos mayores, con múltiples comorbilidades y bajo ingreso; la prevalencia esperada en el Grupo B es **mayor** que en el Grupo A. Si se asume 25% frente a 15%, los falsos negativos pasan a **495 vs. 2,100** (4.24 veces más). El sesgo de etiqueta de Q1 hace que el grupo más enfermo sea, a la vez, el más subestimado.

### 3.4 Consecuencias adicionales

- **Doble penalización:** el Grupo B recibe más falsos negativos (se le niega el beneficio) y más falsos positivos (se le somete a intervenciones innecesarias). Ambos errores recaen sobre el mismo grupo.
- **Violación de igualdad de oportunidades:** la brecha de TPR de 31 pp excede cualquier criterio razonable de paridad (habitualmente 10 pp o la regla del 80%). El modelo no ofrece igual probabilidad de detección a igual necesidad.
- **Daño concentrado y evitable:** a diferencia de un error estadístico distribuido, aquí el daño se concentra en pacientes identificables, con desenlace grave y con una intervención disponible que se les niega.
- **Erosión de confianza y riesgo legal:** los médicos de la red pública ya documentaron el patrón. Mantener el sistema en pre-producción con esta evidencia configura negligencia organizacional, no solo un defecto técnico.

---

## Pregunta 4. Infracciones regulatorias normativas

### 4.1 EU AI Act: violaciones explícitas

El sistema es de **alto riesgo** (Anexo III, categoría 5: priorización de acceso a servicios esenciales de salud). Por tanto le resultan exigibles los requisitos del Capítulo III, Sección 2.

#### Violación 1 — Artículo 10: gobernanza de datos

**Obligación:** los conjuntos de entrenamiento, validación y prueba deben ser pertinentes, suficientemente representativos, estar lo más libres posible de errores y ser completos para el propósito previsto; deben examinarse en busca de sesgos que puedan afectar la salud, los derechos fundamentales o generar discriminación (Art. 10.2.f y 10.3).

**Evidencia del incumplimiento:**

- 250,000 registros históricos 2018–2023 que codifican inequidades de acceso preexistentes, sin evidencia de muestreo compensatorio.
- Desbalance de subgrupos: 30,000 (A) frente a 20,000 (B), sin ponderación ni análisis de representatividad.
- Uso de proxies socioeconómicos (`Gasto`, `Código_Postal`, `Tipo_Afiliación`) que concentran el 65% del peso.
- El reporte del modelo **no contiene** análisis de sesgo por subgrupo; solo métricas globales.

**Consecuencia:** el dataset no es representativo ni está libre de sesgos en el sentido del artículo. La disparidad de FNR (11% vs. 42%) es la prueba empírica de que el examen de sesgos no se realizó o se realizó de forma insuficiente.

#### Violación 2 — Artículo 13: transparencia y provisión de información

**Obligación:** el sistema debe diseñarse para que su funcionamiento sea suficientemente transparente y permita a los responsables de su despliegue interpretar los resultados y usarlos adecuadamente; debe acompañarse de instrucciones de uso con las características, capacidades y limitaciones del sistema (Art. 13.1 y 13.3).

**Evidencia del incumplimiento:**

- No existe explicación a nivel de paciente. Solo se reportan importancias SHAP **globales**, que no permiten a un médico justificar por qué *este* paciente recibió 38/100.
- No se documentan las limitaciones del sistema: el reporte no advierte que el target es un proxy de gasto ni que el desempeño se degrada en el Grupo B.
- El clínico recibe un score sin intervalo de confianza, sin variables contribuyentes y sin advertencia de subgrupo.
- No consta documentación técnica ni instrucciones de uso para el personal sanitario.

**Consecuencia:** el usuario no puede interpretar el resultado ni usarlo adecuadamente. La opacidad no es un detalle de interfaz: es la condición que permite que un score sesgado se convierta en una decisión clínica sin cuestionamiento.

#### Violación 3 — Artículo 14: supervisión humana

**Obligación:** el sistema debe diseñarse para ser supervisado efectivamente por personas físicas competentes, con mecanismos que permitan comprender sus capacidades y limitaciones, detectar anomalías, interpretar la salida y **decidir no utilizarla o anularla** (Art. 14.1 y 14.3).

**Evidencia del incumplimiento:**

- No se describe ningún mecanismo de revisión médica previa a la exclusión del programa.
- El flujo reportado es automático: score < 40 → rechazo del ingreso al programa.
- No hay registro de anulaciones, segundas opiniones ni revisión de casos limítrofes.
- El personal médico detectó el patrón **por la vía de la queja**, no por un panel de control diseñado para ello.

**Consecuencia:** existe un modelo desplegado sobre decisiones clínicas sin *human-in-the-loop* real. La supervisión humana es nominal, no efectiva.

#### Violación 4 — Artículo 15: exactitud, robustez y ciberseguridad

**Obligación:** el sistema debe alcanzar un nivel adecuado de exactitud, robustez y ciberseguridad, y comportarse de forma consistente a lo largo de su ciclo de vida (Art. 15.1 y 15.3).

**Evidencia del incumplimiento:**

- La exactitud global (88.5%) enmascara un recall de 58% en el Grupo B.
- No hay métricas de calibración, estabilidad ni desempeño por subgrupo.
- No se reportan pruebas de robustez ante datos faltantes, cambios de codificación o deriva poblacional.
- No se documenta el comportamiento ante entradas atípicas ni la sensibilidad a errores de registro.

**Consecuencia:** el nivel de exactitud no es adecuado para el subgrupo más vulnerable, y no hay evidencia de consistencia en el ciclo de vida.

#### Otras obligaciones incumplidas (refuerzo)

- **Art. 9:** sistema de gestión de riesgos continuo, inexistente a la vista del dossier.
- **Art. 12:** registro automático de eventos (*logs*) que permita trazar decisiones, no documentado.
- **Art. 86:** derecho del afectado a obtener una explicación clara y significativa de la decisión. Un score opaco lo impide.
- **Art. 72:** vigilancia poscomercial; no hay plan de monitoreo.
- **Art. 27:** evaluación de impacto en derechos fundamentales, exigible a entidades públicas y obligatoria antes del despliegue.

### 4.2 NIST AI RMF 1.0: falla principal en MEASURE

**Función incumplida: MEASURE (Medir).**

El Marco exige análisis cuantitativo y cualitativo de precisión, disparidad de sesgo, robustez y deriva. La v2.4 solo reporta métricas agregadas:

| Métrica exigida por MEASURE | Estado en el dossier |
|---|---|
| Exactitud global | Reportada (88.5%, AUC 0.89) — insuficiente |
| Desempeño por subgrupo | **Ausente** en el reporte del modelo; aparece solo en la queja (Documento B) |
| Paridad de errores (FNR/FPR) | **No evaluada**; la brecha 11% vs. 42% no fue detectada por el equipo |
| Calibración | **No reportada** |
| Robustez y sensibilidad | **No reportada** |
| Deriva (drift) | **No monitoreada** |
| Validez del constructo | **No cuestionada**: se acepta el proxy de gasto sin análisis |

La falla es de fondo: el equipo midió lo que el modelo hace bien (accuracy, AUC) y no midió lo que el marco exige (equidad, robustez, validez). Un AUC de 0.89 sobre un target mal definido no es evidencia de calidad; es evidencia de que el modelo predice consistentemente el constructo equivocado.

**Incumplimientos secundarios en las otras tres funciones:**

- **MAP:** no se contextualizó a la población afectada ni se mapearon los riesgos de sesgo, privacidad y seguridad. No hay análisis de stakeholders ni de impacto diferencial por régimen.
- **GOVERN:** no se definieron tolerancias al riesgo ni responsables de equidad. No hay política de aprobación, auditoría independiente ni rendición de cuentas.
- **MANAGE:** no hay plan de mitigación, priorización ni respuesta ante los hallazgos. El sistema permanece en pre-producción con una disparidad conocida y sin acción correctiva.

### 4.3 Síntesis normativa

| Marco | Obligación | Evidencia | Estado |
|---|---|---|---|
| EU AI Act Art. 10 | Datos representativos y sin sesgos | FNR 11% vs. 42%; proxies 65% | **Violado** |
| EU AI Act Art. 13 | Transparencia interpretable | Solo SHAP global; sin explicación por paciente | **Violado** |
| EU AI Act Art. 14 | Supervisión humana efectiva | Rechazo automático; sin revisión médica | **Violado** |
| EU AI Act Art. 15 | Exactitud y robustez | Recall 58% en Grupo B; sin calibración ni drift | **Violado** |
| NIST AI RMF — MEASURE | Métricas de sesgo, robustez y deriva | Solo métricas globales | **No cumplido** |
| NIST AI RMF — MAP | Contextualización y riesgos | Sin análisis de subgrupos | **No cumplido** |
| NIST AI RMF — GOVERN | Políticas y tolerancias | Sin responsables ni umbrales | **No cumplido** |
| NIST AI RMF — MANAGE | Mitigación y monitoreo | Sin plan correctivo | **No cumplido** |

La conclusión normativa es convergente: el sistema no puede autorizarse en su estado actual. No se trata de un ajuste de umbral ni de una mejor interfaz, sino de un defecto de definición del objetivo, de selección de variables y de ausencia de medición desagregada. Cualquiera de las cuatro violaciones del EU AI Act bastaría para impedir el despliegue.

---

## Insumos para el informe final

| ID | Dimensión | Hallazgo | Riesgo |
|---|---|---|---|
| H-01 | Fairness | Target definido por gasto futuro: sesgo de etiqueta y validez de constructo | Crítico |
| H-02 | XAI | 65% del peso en proxies socioeconómicos; sin explicación por paciente | Crítico |
| H-03 | Privacidad | `Código_Postal` y `Tipo_Afiliación` permiten inferir atributos sensibles | Alto |
| H-04 | Robustez | Brecha de FNR 11% vs. 42%; sin monitoreo de deriva ni calibración | Crítico |

---

## Referencias

- Reglamento (UE) 2024/1689 (EU AI Act), Anexo III y arts. 9, 10, 12, 13, 14, 15, 27, 72 y 86.
- NIST, *Artificial Intelligence Risk Management Framework (AI RMF 1.0)*, NIST AI 100-1, 2023.
- Obermeyer, Z., Powers, B., Vogeli, C. y Mullainathan, S., «Dissecting racial bias in an algorithm used to manage the health of populations», *Science*, 366(6464), 2019, pp. 447–453.
- Barocas, S. y Selbst, A. D., «Big Data's Disparate Impact», *California Law Review*, 104, 2016, pp. 671–732.
