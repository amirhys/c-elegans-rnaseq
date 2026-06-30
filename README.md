# C. elegans RNA-seq Analysis Pipeline (Docker + Transcript Analysis)

This repository contains a complete RNA-seq analysis workflow for *Caenorhabditis elegans* data, including transcript-level quantification, exon-level analysis, and modeling of cryptic transcription using regression-based approach.

The project integrates **Dockerized bioinformatics pipelines**, **HPC execution (SLURM)**, and **R-based downstream statistical analysis**.

---

## Project Overview

The goal of this project is to analyze transcriptomic changes across different C. elegans conditions (wt, ama1, daf2, young vs old) and to investigate **cryptic transcription patterns at exon resolution**.

---

## Pipeline Structure

### 1. RNA-seq Quantification (Docker + Salmon)

- Transcript quantification using `Salmon`
- Dockerized execution for reproducibility
- SLURM-based batch processing on HPC cluster

📁 `docker/salmon_quant/`

---

### 2. Gene-Level Summarization

- Transcript-to-gene mapping using GTF annotation
- Filtering of protein-coding transcripts
- Gene-level aggregation for downstream PCA

---

### 3. Major Transcript Selection

- Identification of the dominant transcript per gene
- Based on mean TPM across conditions
- Used for downstream comparative analysis

---

### 4. Exon-Level Analysis (featureCounts)

- Exon read quantification
- Normalization (TPM / EPM)
- Calculation of relative exon expression (Ei)

---

### 5. Statistical Modeling

- Linear regression of exon expression across gene structure
- Slope-based detection of transcriptional bias
- Comparison across conditions

---

### 6. Differential Structure Analysis

- Fold-change of exon expression ratios between conditions
- Boxplots and distribution analysis of structural changes

---

### 7. Dimensionality Reduction (PCA)

- DESeq2-based normalization (VST)
- PCA on transcript and major transcript subsets
- Visualization of global expression differences

---

## Key Outputs

- PCA plots of global expression structure
- Exon-level expression profiles (Ei curves)
- Regression-based slope comparisons
- Major transcript consistency matrices
- Condition-specific fold-change distributions

---

##  Technologies Used

- R (tidyverse, DESeq2, tximport, ggplot2, rtracklayer)
- Python (job automation scripts for HPC)
- Docker (reproducible pipelines)
- SLURM (cluster execution)
- Salmon (transcript quantification)
- featureCounts (exon-level quantification)

---

## 📁 Repository Structure

```text
analysis/
    PCA.qmd
    regression.qmd
    data_analysis.qmd
    data_analysis.R

docker/
    salmon_quant/
    salmon_indexing/
    featureCounts/

results/
    plots and intermediate outputs (excluded from git)
