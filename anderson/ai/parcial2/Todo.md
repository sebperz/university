# To Do
Entregar un documento de Word con:
- 50 ejecuciones de **una** CNN Pre-entrenada
- Sobre un base de datos etiquetada.
- Realizar un analisis estadistico de los resultados y evidenci.
  - Accuracy | Loss | Val_Acc | Val_Loss [preguntarle a la IA como hacer un informe asi bien bacan]


Ver como implementar esta monda:
import pandas as pd
df = pd.DataFrame(history.history)
df.to_excel('history.xlsx', index=False)
