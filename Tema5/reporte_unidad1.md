\# Reporte de cierre de la Unidad I (Tema 5)



\## a) Estadísticos descriptivos principales



\- \*\*nota:\*\* media 13.57, desviación estándar muestral 3.10, coeficiente de variación 22.85%.

\- \*\*asistencia\_pct:\*\* media 82.0, desviación estándar muestral 8.47, coeficiente de variación 10.32%.



\## b) Nivel de dispersión según `clasificar\_dispersion()`



\- \*\*nota:\*\* dispersión \*\*Moderada\*\* (CV entre 15% y 30%).

\- \*\*asistencia\_pct:\*\* dispersión \*\*Baja\*\* (CV menor a 15%).



Aunque la desviación estándar de `asistencia\_pct` (8.47) es mayor en número que la de `nota` (3.10), su dispersión relativa es menor porque su media también es mucho más alta (82 contra 13.57). Por eso el CV, que es relativo a la media, da a `asistencia\_pct` como menos disperso.



\## c) Observación sobre convenciones entre librerías



La media, la mediana y la desviación estándar salieron iguales en pandas y en R. Pero la varianza no: numpy (`np.var`) dio 8.24 porque usa `ddof=0` (poblacional), mientras que `var()` de R dio 9.62 porque usa `ddof=1` (muestral) por defecto. Lo mismo pasó con skewness y kurtosis: pandas y e1071 usan fórmulas ligeramente distintas, así que los valores no coincidieron exactamente aunque el signo y la forma general de la distribución sí fueron parecidos.

