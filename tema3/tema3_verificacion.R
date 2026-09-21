notas <- c(11, 14, 20, 8, 16, 13)

primero <- notas[1]
ultimo <- notas[length(notas)]
print(primero)
print(ultimo)

promedio <- mean(notas)
maximo <- max(notas)
cantidad_aprobados <- sum(notas >= 10.5)
print(promedio)
print(maximo)
print(cantidad_aprobados)

library(tidyverse)

datos <- tibble(
  nombre         = c("Camila", "Diego", "Valeria", "Jorge", "Luz"),
  nota           = c(16, 9, 13, 18, 11),
  asistencia_pct = c(90, 85, 60, 75, 72)
)
print(datos)

filtrados <- filter(datos, nota >= 10.5 & asistencia_pct >= 70)
print(filtrados)