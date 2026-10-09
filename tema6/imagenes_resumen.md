# Resumen de imágenes sintéticas (Tema 6)

## a) Dimensiones de las imágenes

- **Degradado en escala de grises:** matriz de **5×5** (`shape (5, 5)`), un solo canal, valores de 0 a 255.
- **Imagen RGB de dos mitades:** array de **4×4×3** (`shape (4, 4, 3)`): 4 filas, 4 columnas y 3 canales de color (R, G, B).

## b) Colores elegidos y su luminosidad

- **Mitad izquierda:** rojo puro `(255, 0, 0)` → luminosidad ponderada = **76.245**.
- **Mitad derecha:** azul puro `(0, 0, 255)` → luminosidad ponderada = **29.07**.

Con el promedio simple, ambos colores dieron el mismo valor (85.0), porque los dos tienen un solo canal "al máximo" y los otros dos en cero. La luminosidad sí los distingue, porque le da más peso al canal verde (0.587) y menos al azul (0.114), y el rojo pesa más que el azul (0.299 contra 0.114).

## c) Umbral de binarización

Usé un umbral de **50** en vez de 128. Elegí ese valor porque mis dos colores dieron luminosidades de 76.245 y 29.07, ambas por debajo de 128; con un umbral de 128 las dos mitades habrían quedado en negro (0) y no se habría visto ninguna diferencia. Con el umbral en 50, el rojo (76.245) queda como blanco y el azul (29.07) como negro, y la binarización sí refleja la diferencia entre mis dos colores.
