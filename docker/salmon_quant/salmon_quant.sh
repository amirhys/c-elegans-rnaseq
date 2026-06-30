#!/bin/bash
## Salmon quantification script


index=/mnt/input_data/salmon_index

# Arguments for input FASTQ files and output directory
fastq1=$1
fastq2=$2
output_dir=$3

echo ls /mnt/input_data/FASTQ/K002000093_54875/

ls /mnt/input_data/FASTQ/K002000093_54875/

# Run Salmon quant
salmon quant \
    -i ${index} \
    -l A \
    -1 ${fastq1} \
    -2 ${fastq2} \
    -p 8 \
    --validateMappings \
    -o ${output_dir}