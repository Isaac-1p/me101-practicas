fila <- seq(0, 255, length.out = 5)
gris <- matrix(rep(fila, times = 5), nrow = 5, byrow = TRUE)

print(gris)
print(dim(gris))
print(mean(gris))

rgb <- array(0, dim = c(4, 4, 3))

rgb[, 1:2, 1] <- 255
rgb[, 1:2, 2] <- 0
rgb[, 1:2, 3] <- 0

rgb[, 3:4, 1] <- 0
rgb[, 3:4, 2] <- 0
rgb[, 3:4, 3] <- 255

print(rgb[1, 1, ])
print(rgb[1, 4, ])

gris_luminosidad <- 0.299 * rgb[, , 1] + 0.587 * rgb[, , 2] + 0.114 * rgb[, , 3]
print(gris_luminosidad)
