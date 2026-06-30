library(tidyverse)
library(tximport)
library(readr)
library(rtracklayer)
library(dplyr)
library(ggplot2)

samples <- c(
  "wt", "wt", "wt", "ama1", "ama1", "ama1", 
  "daf2", "daf2", "daf2", "wtday1", "wtday1", "wtday1", 
  "ama1day1", "ama1day1", "ama1day1"
)

names(samples) <- c(
  "K002000093_54873", "K002000093_54875", "K002000093_54877", 
  "K002000093_54879", "K002000093_54881", "K002000093_54883", 
  "K002000093_54885", "K002000093_54887", "K002000093_54889", 
  "K002000244_89704", "K002000244_89706", "K002000244_89708", 
  "K002000244_89710", "K002000244_89712", "K002000244_89714"
)

samples_dict <- list(c("K002000093_54873", "K002000093_54875", "K002000093_54877"),
                c("K002000093_54879", "K002000093_54881", "K002000093_54883"),
                c("K002000093_54885", "K002000093_54887", "K002000093_54889"),
                c("K002000244_89704", "K002000244_89706", "K002000244_89708"),
                c("K002000244_89710", "K002000244_89712", "K002000244_89714"))



names(samples_dict) <- unique(samples)

#View(samples_dict)

setdiff_both <- function(x, y) {
  union(setdiff(x, y), setdiff(y, x))
}


common_path <- '/cellfile/datapublic/ahyseni/cryption/c.elegans/docker/salmon_quant/output'

# reading in the salmon quantification files, e.g.: /cellfile/datapublic/ahyseni/cryption/c.elegans/docker/salmon_quant/output/wt/K002000093_54873/quant.sf

quant_filepaths <- file.path(common_path, samples, names(samples), "quant.sf")

quant_filepaths
# load the files in one matirx
all_quant_files <- tximport(quant_filepaths, type = "salmon", txOut = TRUE)

names(all_quant_files)

# extract only TMP vals
all_TPMs <- all_quant_files$abundance
all_lengths <- all_quant_files$length

colnames(all_TPMs) <- paste0(names(samples), '_', samples)
colnames(all_lengths) <- paste0(names(samples), '_', samples)

long_transcripts <- as.data.frame(all_lengths) %>%
  mutate(mean_length = rowMeans(across(starts_with("K")))) %>%
  filter(mean_length > 1000)

#View(long_transcripts)
length(rownames(long_transcripts))

# load gtf file
gtf_filepath <- '/cellfile/datapublic/ahyseni/cryption/c.elegans/data/reference_omes/Caenorhabditis_elegans.WBcel235.90.gtf'
gtf_data <- import(gtf_filepath)
gtf_df <- as.data.frame(mcols(gtf_data))

# extract relevant columns from gtffile (gene_id and transcript_id)

gene_transcript_map <- gtf_df %>%
  filter(type == "transcript") %>%
  filter(transcript_biotype == "protein_coding") %>% 
  select(gene_id, gene_name, transcript_id) %>%  
  distinct()

#View(gtf_df %>% filter(transcript_id == 'C53C7.5b'))

all_TPMs_with_genes <- as.data.frame(all_TPMs) %>%
  rownames_to_column("transcript_id") %>%
  filter(transcript_id %in% gene_transcript_map$transcript_id) %>%
  left_join(gene_transcript_map, by = "transcript_id")

length(all_TPMs_with_genes$transcript_id)
length(gene_transcript_map$transcript_id)

filtered_TPMs <- all_TPMs_with_genes %>%
  filter(transcript_id %in% rownames(long_transcripts))


major_tr_list <- list()


for (i in names(samples_dict)) {
  print(i)
  major_tr <- filtered_TPMs %>%
  #filter(colname > 1000) %>%
  group_by(gene_id) %>%
  mutate(mean_TPM = rowMeans(across(ends_with(i)))) %>%
  filter(mean_TPM > 1) %>%
  slice_max(order_by = mean_TPM, n = 1, with_ties = FALSE)
  
  major_tr_list <- append(major_tr_list, list(major_tr[, c('transcript_id', 'mean_TPM','gene_id')]))
}

names(major_tr_list) <- names(samples_dict)
names(major_tr_list)

condition_names <- names(major_tr_list)
ratio_matrix <- matrix(NA, nrow = length(condition_names), ncol = length(condition_names),
                       dimnames = list(condition_names, condition_names))


for (i in 1:(4)) {
  for (j in (i + 1):5) {

    intersect_len <- length(intersect(major_tr_list[[i]]$transcript_id, major_tr_list[[j]]$transcript_id))
    diff_len <- length(setdiff_both(major_tr_list[[i]]$transcript_id, major_tr_list[[j]]$transcript_id))
  
    ratio <- intersect_len / (intersect_len + diff_len)
    ratio_matrix[i, j] <- ratio
    ratio_matrix[j, i] <- ratio 
  }
}
write.csv(ratio_matrix, "ratio_matrix.csv", row.names = TRUE)
#View(ratio_matrix)


intersect_len <- Reduce(intersect, 
                  list(major_tr_list[[1]]$transcript_id,
                       major_tr_list[[2]]$transcript_id,
                       major_tr_list[[3]]$transcript_id,
                       major_tr_list[[4]]$transcript_id,
                       major_tr_list[[5]]$transcript_id)) %>% length()


diff_len <- Reduce(setdiff_both, 
                  list(major_tr_list[[1]]$transcript_id,
                       major_tr_list[[2]]$transcript_id,
                       major_tr_list[[3]]$transcript_id,
                       major_tr_list[[4]]$transcript_id,
                       major_tr_list[[5]]$transcript_id)) %>% length()

ratio <- intersect_len / (intersect_len + diff_len)
ratio

all_majors <- intersect(major_tr_list[[1]]$transcript_id, major_tr_list[[2]]$transcript_id) %>%
  intersect(major_tr_list[[3]]$transcript_id) %>%
  intersect(major_tr_list[[4]]$transcript_id) %>%
  intersect(major_tr_list[[5]]$transcript_id)

length(all_majors)

# further analysis:
common_path <- '/cellfile/datapublic/ahyseni/cryption/c.elegans/docker/featureCounts/output/'


example <- read.delim(paste0(common_path, 'ama1/K002000093_54879/exon_counts.txt'), comment.char = "#")
#View(example)


Ei_values <- data.frame()

for (sample_name in names(samples)) {
  sample_type <- samples[sample_name]
  print(sample_type)
  file_path <- paste0(common_path, sample_type, "/", sample_name, "/exon_counts.txt")
  
  exon_counts <- read.delim(file_path, comment.char = "#")
    
  colnames(exon_counts)[7] <- 'bam_counts'
    
  exon_counts <- mutate(exon_counts, normalized_counts = (bam_counts / Length) * 10^6)
  
  filtered_exon_counts <- exon_counts %>%
    group_by(Geneid) %>%
    filter(n() >= 5)
  

  Ei_for_sample <- filtered_exon_counts %>%
    group_by(Geneid) %>%
    mutate(Ei = normalized_counts / normalized_counts[1]) %>%
    mutate(Exon = ifelse(row_number() == n(), "last", as.character(row_number()))) %>%
    filter(Exon %in% c("2", "3", "4", "last")) %>%
    select(Geneid, Exon, Ei) %>%
    mutate(Sample = sample_name, SampleType = sample_type)

  Ei_values <- bind_rows(Ei_values, Ei_for_sample)
}

#View(Ei_values)

#View(filtered_exon_counts)
Ei_mean <- data.frame()
Ei_mean <- Ei_values %>%
  group_by(SampleType, Geneid, Exon) %>%
  summarize(mean_Ei = mean(Ei, na.rm = TRUE), .groups = 'drop')

get_FCs <- function(compared1, compared2) {
  FC <- Ei_mean %>%
  filter(SampleType %in% c(compared1, compared2)) %>%
  filter(Geneid %in% intersect(major_tr_list[[compared1]]$transcript_id, major_tr_list[[compared2]]$transcript_id)) %>%
  pivot_wider(names_from = SampleType, values_from = mean_Ei, names_prefix = "mean_") %>%
  mutate(FC_vals = get(paste0("mean_", compared1)) / get(paste0("mean_", compared2))) 
}

FC_wt_wtday1 <- get_FCs('wt', 'wtday1')
FC_wt_daf2 <- get_FCs('wt', 'daf2')
FC_wt_ama1 <- get_FCs('wt', 'ama1')
FC_ama1_ama1day1 <- get_FCs('ama1', 'ama1day1')

make_plots <- function(data) {
  if (grepl('FC', deparse(substitute(data)))) {
    vals <- data$FC_vals
    color1 <- "skyblue"
    color2 <- "darkblue"
  } else {
    vals <- data$Ei
    color1 <- "red"
    color2 <- "firebrick"	
  }


  ggplot(data, aes(x = factor(Exon), y = log2(vals))) +
  geom_boxplot(fill = color1, color = color2) +
    #coord_cartesian(ylim = c(-2, 2)) +
  labs(x = "Exon Position", y = "Fold Change (FC)", 
       title = "Distribution of Fold Changes Across Exons",
       subtitle = deparse(substitute(data))) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 26, hjust = 0.5, family = "Arial"),
    plot.subtitle = element_text(size = 26, hjust = 0.5, family = "Arial"),
    axis.title.x = element_text(size = 23, family = "Arial"),
    axis.title.y = element_text(size = 23, family = "Arial")
  )
}

make_plots(FC_wt_wtday1)
make_plots(FC_wt_daf2)
make_plots(FC_wt_ama1)
make_plots(FC_ama1_ama1day1)


length(Ei_values$Geneid)

Ei_values_new <- Ei_values %>%
  filter(Geneid %in% all_majors)

length(all_majors)
length(Ei_values_new$Geneid)

#saveRDS(FC_wt_wtday1, "FC_wt_wtday1.rds")
#saveRDS(FC_wt_daf2, "FC_wt_daf2.rds")
#saveRDS(FC_wt_ama1, "FC_wt_ama1.rds")
#saveRDS(FC_ama1_ama1day1, "FC_ama1_ama1day1.rds")
#saveRDS(Ei_values_new, "Ei_values.rds")

#View(Ei_values)


Ei_values %>%
  filter(Exon == '2') %>%
  summarise(median_Ei = median(Ei, na.rm = TRUE))

summary(FC_wt_wtday1$FC_vals)
View(FC_wt_wtday1)
