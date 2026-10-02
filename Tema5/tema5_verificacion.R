library(tidyverse)
library(e1071)

df <- read_csv("estudiantes_limpio_R.csv")

media <- mean(df$nota)
mediana <- median(df$nota)
desv_std <- sd(df$nota)
varianza <- var(df$nota)
q1 <- quantile(df$nota, 0.25)
q3 <- quantile(df$nota, 0.75)
rango_iqr <- IQR(df$nota)

print(media)
print(mediana)
print(desv_std)
print(varianza)
print(q1)
print(q3)
print(rango_iqr)

skew_e1071 <- skewness(df$nota)
kurt_e1071 <- kurtosis(df$nota)
print(skew_e1071)
print(kurt_e1071)

resumen_estadistico <- function(vector, decimales = 4) {
  media <- mean(vector)
  desv_std <- sd(vector)
  list(
    n = length(vector),
    media = round(media, decimales),
    mediana = round(median(vector), decimales),
    desv_std = round(desv_std, decimales),
    cv_pct = round(desv_std / media * 100, decimales)
  )
}
print(resumen_estadistico(df$nota))

clasificar_dispersion <- function(cv_pct) {
  if (cv_pct < 15) {
    "Baja"
  } else if (cv_pct < 30) {
    "Moderada"
  } else {
    "Alta"
  }
}

for (columna in c("nota", "asistencia_pct")) {
  resumen <- resumen_estadistico(df[[columna]])
  nivel <- clasificar_dispersion(resumen$cv_pct)
  cat(columna, "->", nivel, "\n")
  print(resumen)
}

