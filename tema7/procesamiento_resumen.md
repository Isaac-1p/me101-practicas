# Resumen de procesamiento de imágenes — Tema 7

**(a) Imagen y elementos usados.** Usé una fotografía de mi perro Nubi (720×1280 px, RGB): un perro gris con una toalla azul sobre piso de baldosas claras, junto a una pared crema. No dibujé figuras con ImageDraw; en su lugar analicé tres zonas de la foto: la pared (fondo) en (600, 200) con color (190, 177, 169), la toalla azul en (330, 720) con color (61, 74, 106) y la nariz del perro en (150, 570) con color (25, 19, 23).

**(b) convert('L') vs rgb2gray().** En el píxel de fondo (600, 200), Pillow dio 180 y scikit-image dio 179.19. No coinciden exactamente (diferencia de unos 0.8 niveles de gris). Pillow usa pesos 0.299 R + 0.587 G + 0.114 B y devuelve enteros uint8. scikit-image usa pesos distintos (0.2125, 0.7154, 0.0721) y devuelve flotantes entre 0 y 1, que multipliqué por 255.

**(c) Umbral de Otsu.** El umbral fue 0.5007 (≈ 127.7 en escala 0-255). El 77.9 % de los píxeles quedó por encima del umbral (True), porque la pared, el piso y el pelo claro ocupan la mayor parte de la imagen, mientras que la toalla, la nariz y las sombras quedan por debajo.
