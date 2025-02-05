library(BiocManager)
library(tercen)
library(dplyr)
library(flowCore)
library(properties)

# force disabling scientific notation
options(scipen = 999)

fcs_to_data = function(filename) {
  data_fcs = read.FCS(filename, transformation = FALSE)
  as.data.frame(exprs(data_fcs)) %>% 
    select(cluster_id) %>%
    mutate(cluster_id = as.character(cluster_id))
}

ctx = tercenCtx()

# create fcs file
fcs_filename  <- "input.fcs"
clusters      <- ctx$rselect() %>% pull()
res           <- t(ctx$as.matrix())
colnames(res) <- clusters
frame         <- flowCore::flowFrame(res)
write.FCS(frame, fcs_filename)

# create fcsFileList.txt
write.table(fcs_filename, file = "fcsFileList.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)

num_nearest_neighbors = ctx$op.value('num_nearest_neighbors')
if (is.null(num_nearest_neighbors)) {
  num_nearest_neighbors <- ""
} else if (num_nearest_neighbors != "") {
  # if it's a string it should be auto
  if (is.na(suppressWarnings(as.numeric(num_nearest_neighbors)))) {
    if (num_nearest_neighbors != "auto") {
      stop("num_nearest_neighbors should be empty, a numeric value or equal to 'auto'.")
    }
  } else {
    num_nearest_neighbors <- as.numeric(num_nearest_neighbors)
  }
}
transformation             = ifelse(is.null(ctx$op.value('transformation')), "ASINH", ctx$op.value('transformation'))
scaling_factor             = ifelse(is.null(ctx$op.value('scaling_factor')), "5", ctx$op.value('scaling_factor'))
noise_threshold            = ifelse(is.null(ctx$op.value('noise_threshold')), "1.0", ctx$op.value('noise_threshold'))
euclidian_length_threshold = ifelse(is.null(ctx$op.value('euclidian_length_threshold')), "0.0", ctx$op.value('euclidian_length_threshold'))
rescale                    = ifelse(is.null(ctx$op.value('rescale')), "NONE", ctx$op.value('rescale'))
quantile                   = ifelse(is.null(ctx$op.value('quantile')), "0.95", ctx$op.value('quantile'))
rescale_separately         = ifelse(is.null(ctx$op.value('rescale_separately')), "false", ctx$op.value('rescale_separately'))

cluster_columns <- paste(seq(ncol(res)), collapse = ",")
# create importConfig.txt
write.properties(file = file("importConfig.txt"),
                 properties = list(clustering_columns         = cluster_columns,
                                   limit_events_per_file      = "-1",
                                   transformation             = transformation,
                                   scaling_factor             = scaling_factor,
                                   noise_threshold            = noise_threshold,
                                   euclidian_length_threshold = euclidian_length_threshold,
                                   rescale                    = rescale,
                                   quantile                   = quantile,
                                   rescale_separately         = rescale_separately))

system(paste("java -Xmx32G -cp VorteX.jar -Djava.awt.headless=true standalone.Xshift", num_nearest_neighbors))

# read output and write to tercen
fcs_to_data(file.path("out", fcs_filename)) %>%
  as_tibble() %>%
  mutate(.ci = seq_len(nrow(.)) - 1) %>%
  ctx$addNamespace() %>%
  ctx$save()