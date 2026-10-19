library(magick)

# Ruta de mi fotografia.
# En R utilizo / para escribir la ruta de Windows.
ruta <- "C:/Users/Fernando/Downloads/pollito.jpeg"

if (!file.exists(ruta)) {
  stop("No se encontro pollito.jpeg. Revisa el nombre y la ubicacion.")
}

# Abrir la imagen y ajustar su orientacion.
img <- image_read(ruta)[1]
img <- image_orient(img)
img <- image_convert(
  img,
  colorspace = "sRGB",
  type = "TrueColor",
  depth = 8
)

# Obtener sus dimensiones reales.
informacion <- image_info(img)
ancho <- informacion$width[1]
alto <- informacion$height[1]

print(informacion)

# Crear la carpeta donde se guardaran los resultados.
salida <- file.path(dirname(ruta), "pollito_resultados_R")
dir.create(salida, showWarnings = FALSE, recursive = TRUE)

# Mostrar varias imagenes juntas.
mostrar <- function(imagenes, titulos,
                    columnas = length(imagenes)) {
  
  configuracion <- par(
    mfrow = c(ceiling(length(imagenes) / columnas), columnas),
    mar = c(0.5, 0.5, 2, 0.5)
  )
  
  on.exit(par(configuracion))
  
  for (i in seq_along(imagenes)) {
    vista <- image_resize(imagenes[[i]], "900x900>")
    plot(as.raster(vista), interpolate = FALSE)
    title(main = titulos[i], line = 0.3, cex.main = 0.9)
  }
}

# Guardar una imagen procesada.
guardar <- function(imagen, nombre) {
  invisible(
    image_write(
      imagen,
      path = file.path(salida, nombre),
      format = "png"
    )
  )
}

# Mostrar mi fotografia.
mostrar(list(img), "Mi imagen original")

###############################################################################

# 1. REDIMENSIONAMIENTO

ancho_grande <- ancho * 3L
alto_grande <- alto * 3L

ancho_pequeno <- max(1L, ancho %/% 3L)
alto_pequeno <- max(1L, alto %/% 3L)

ampliada <- image_resize(
  img,
  geometry = sprintf("%dx%d!", ancho_grande, alto_grande),
  filter = "Cubic"
)

reducida <- image_resize(
  img,
  geometry = sprintf("%dx%d!", ancho_pequeno, alto_pequeno),
  filter = "Box"
)

dimensiones <- data.frame(
  Imagen = c("Original", "Ampliada x3", "Reducida a 1/3"),
  Ancho = c(ancho, ancho_grande, ancho_pequeno),
  Alto = c(alto, alto_grande, alto_pequeno)
)

print(dimensiones)

titulos <- paste0(
  dimensiones$Imagen, "\n",
  dimensiones$Ancho, " x ", dimensiones$Alto, " pixeles"
)

mostrar(
  list(img, ampliada, reducida),
  titulos
)

guardar(ampliada, "01_ampliada.png")
guardar(reducida, "01_reducida.png")

####################################################################

# 2. ROTACION

rotada <- image_rotate(
  image_background(img, "black"),
  degrees = -30
)

rotada <- image_extent(
  rotada,
  geometry = sprintf("%dx%d", ancho, alto),
  gravity = "center",
  color = "black"
)

mostrar(
  list(img, rotada),
  c("Original", "Rotacion de 30 grados antihorario")
)

guardar(rotada, "02_rotada.png")

##################################################################################

# 3. TRASLACION

fondo <- image_blank(
  width = ancho,
  height = alto,
  color = "black"
)

trasladada <- image_composite(
  fondo,
  img,
  operator = "over",
  offset = "+100+70",
  gravity = "northwest"
)

mostrar(
  list(img, trasladada),
  c("Original", "Desplazamiento: derecha 100, abajo 70")
)

guardar(trasladada, "03_trasladada.png")

####################################################################################

# 4. INCLINACION O CIZALLAMIENTO

inclinada <- image_distort(
  image_virtual_pixel(img, "Black"),
  distortion = "AffineProjection",
  coordinates = c(1, 0, -0.15, 1, 0, 0),
  bestfit = FALSE
)

mostrar(
  list(img, inclinada),
  c("Original", "Inclinacion horizontal: -0.15")
)

guardar(inclinada, "04_inclinada.png")

############################################################################

# 5. NORMALIZACION

# Array de enteros: alto, ancho y canales RGB.
datos_rgb <- as.integer(image_data(img, channels = "rgb"))

normalizada <- datos_rgb

for (canal in 1:3) {
  
  valores <- datos_rgb[, , canal]
  minimo <- min(valores)
  maximo <- max(valores)
  
  if (maximo == minimo) {
    normalizada[, , canal] <- 0
  } else {
    normalizada[, , canal] <-
      (valores - minimo) / (maximo - minimo)
  }
}

# Convertir los valores normalizados en una imagen.
img_normalizada <- image_read(as.raster(normalizada))

# Comprobar el rango de cada canal.
resumen_normalizacion <- data.frame(
  Canal = c("Rojo", "Verde", "Azul"),
  Minimo = sapply(
    1:3, function(k) min(normalizada[, , k])
  ),
  Maximo = sapply(
    1:3, function(k) max(normalizada[, , k])
  )
)

print(resumen_normalizacion)

# Mostrar una pequeña parte del canal rojo.
cat("\nPrimeros valores del canal rojo normalizado:\n")

print(
  round(
    normalizada[
      seq_len(min(5L, alto)),
      seq_len(min(5L, ancho)),
      1
    ],
    digits = 4
  )
)

mostrar(
  list(img, img_normalizada),
  c("Original", "Normalizacion por canal")
)

guardar(img_normalizada, "05_normalizada.png")

###########################################################################

# 6. DETECCION DE BORDES

gris <- image_convert(
  img,
  colorspace = "gray"
)

bordes <- image_canny(
  gris,
  geometry = "0x1+2%+6%"
)

mostrar(
  list(img, bordes),
  c("Original", "Bordes detectados con Canny")
)

guardar(bordes, "06_bordes_canny.png")

#############################################################################

# 7. DESENFOQUE GAUSSIANO

kernel_gauss <- matrix(
  c(
    1, 2, 1,
    2, 4, 2,
    1, 2, 1
  ),
  nrow = 3,
  byrow = TRUE
) / 16

desenfocada <- image_convolve(
  img,
  kernel = kernel_gauss
)

mostrar(
  list(img, desenfocada),
  c("Original", "Desenfoque gaussiano 3 x 3")
)

guardar(desenfocada, "07_desenfocada.png")

####################################################################################

# 8. PROCESAMIENTO MORFOLOGICO

gris <- image_convert(
  img,
  colorspace = "gray"
)

# Dilatacion: dos iteraciones.
dilatada <- image_morphology(
  gris,
  method = "Dilate",
  kernel = "Square:1",
  iterations = 2
)

# Erosion: dos iteraciones.
erosionada <- image_morphology(
  gris,
  method = "Erode",
  kernel = "Square:1",
  iterations = 2
)

# Apertura: erosion seguida de dilatacion.
apertura <- image_morphology(
  gris,
  method = "Open",
  kernel = "Square:1",
  iterations = 1
)

# Cierre: dilatacion seguida de erosion.
cierre <- image_morphology(
  gris,
  method = "Close",
  kernel = "Square:1",
  iterations = 1
)

mostrar(
  list(dilatada, erosionada, apertura, cierre),
  c(
    "Dilatacion: 2 iteraciones",
    "Erosion: 2 iteraciones",
    "Apertura",
    "Cierre"
  ),
  columnas = 2
)

guardar(dilatada, "08_dilatada.png")
guardar(erosionada, "08_erosionada.png")
guardar(apertura, "08_apertura.png")
guardar(cierre, "08_cierre.png")

#############################################3

cat("Resultados guardados en:\n", salida, "\n\n")

archivos <- list.files(
  salida,
  pattern = "\\.png$"
)

print(archivos)
cat("\nCantidad de imagenes guardadas:", length(archivos), "\n")