
library(tidyverse)
library(pheatmap)

# ---------- Tarea 2: ggplot2 ----------

datos <- data.frame(
  centro = c(45, 18.2, 72),
  sanjeronimo   = c(28, 12.5, 58),
  wanchaq   = c(62, 25.4, 81),
  sansebastian    = c(35, 15, 65),
  poroy    = c(0, 9.8, 52)
)

matriz_corr <- cor(datos)
print(round(matriz_corr, 4))

# Formato largo
corr_larga <- matriz_corr |>
  as.data.frame() |>
  rownames_to_column("var1") |>
  pivot_longer(-var1, names_to = "var2", values_to = "correlacion")

print(nrow(corr_larga))                  # debe ser n_variables^2
print(nrow(corr_larga) == ncol(datos)^2)

# Conservar el orden original en los ejes
orden <- colnames(datos)
corr_larga <- corr_larga |>
  mutate(var1 = factor(var1, levels = rev(orden)),
         var2 = factor(var2, levels = orden))

p <- ggplot(corr_larga, aes(x = var2, y = var1, fill = correlacion)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(correlacion, 2)), size = 4) +
  scale_fill_gradient2(
    low = "#2166AC", mid = "white", high = "#B2182B",
    midpoint = 0, limits = c(-1, 1)
  ) +
  coord_fixed() +
  labs(title = "Matriz de correlación", x = NULL, y = NULL, fill = "r") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(p)
ggsave("heatmap_ggplot2.png", p, width = 6, height = 5, dpi = 150)

# ---------- Tarea 3: pheatmap ----------

# CON agrupamiento (por defecto)
pheatmap(
  matriz_corr,
  display_numbers = TRUE,
  number_format = "%.2f",
  breaks = seq(-1, 1, length.out = 101),
  color = colorRampPalette(c("#2166AC", "white", "#B2182B"))(100),
  filename = "heatmap_pheatmap_agrupado.png",
  width = 6, height = 5
)

# SIN agrupamiento
pheatmap(
  matriz_corr,
  cluster_rows = FALSE,
  cluster_cols = FALSE,
  display_numbers = TRUE,
  number_format = "%.2f",
  breaks = seq(-1, 1, length.out = 101),
  color = colorRampPalette(c("#2166AC", "white", "#B2182B"))(100),
  filename = "heatmap_pheatmap_sin_agrupar.png",
  width = 6, height = 5
)

# Orden de variables (para la pregunta de cierre)
res <- pheatmap(matriz_corr, silent = TRUE)
cat("Orden CON agrupamiento:", rownames(matriz_corr)[res$tree_row$order], "\n")
cat("Orden SIN agrupamiento:", rownames(matriz_corr), "\n")
