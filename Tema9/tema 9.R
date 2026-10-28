library(pheatmap)
library(RColorBrewer)

# --- Parte C ---
df <- data.frame(
  PM10  = c(45.0, 28.0, 62.0, 35.0, NA),
  NO2   = c(18.2, 12.5, 25.4, 15.0, 9.8),
  Ruido = c(72, 58, 81, 65, 52),
  row.names = c("Centro", "San Jerónimo", "Wanchaq", "San Sebastián", "Poroy"))
for (col in names(df)) {
  df[is.na(df[, col]), col] <- median(df[, col], na.rm = TRUE)
}
df_z <- as.data.frame(scale(df))
print(round(df_z, 2))

lim <- max(abs(as.matrix(df_z)))
pal <- colorRampPalette(rev(brewer.pal(11, "RdBu")))(100)
brk <- seq(-lim, lim, length.out = 101)

png("parteC_heatmap_R.png", width = 7, height = 5, units = "in", res = 300)
pheatmap(as.matrix(df_z), color = pal, breaks = brk,
         cluster_rows = FALSE, cluster_cols = FALSE,
         display_numbers = TRUE, number_format = "%.2f",
         border_color = "gray", fontsize_number = 10,
         main = "Indicadores de calidad ambiental (Z-score)")
dev.off()

# --- Parte D ---
png("parteD_clustermap_R.png", width = 7, height = 6, units = "in", res = 300)
pheatmap(as.matrix(df_z),
         clustering_distance_rows = "euclidean",
         clustering_distance_cols = "euclidean",
         clustering_method = "ward.D2",
         color = pal, breaks = brk,
         display_numbers = TRUE, number_format = "%.2f",
         border_color = "gray",
         main = "Clustermap con dendrogramas (Euclidiana, Ward.D2)")
dev.off()