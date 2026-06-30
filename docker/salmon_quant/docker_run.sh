docker run -it --rm -v /cellfile/datapublic/ahyseni/cryption/c.elegans/data:/mnt/input_data \
                -v /cellfile/datapublic/ahyseni/cryption/c.elegans/docker/salmon_quant/output:/mnt/output \
                -v /cellfile/datapublic/ahyseni/cryption/c.elegans/docker/salmon_quant/:/mnt/salmon_quant \
                salmon_quant_docker # /mnt/input_data/FASTQ/K002000093_54873/R1.fastq.gz /mnt/input_data/FASTQ/K002000093_54873/R2.fastq.gz /mnt/output/wt/K002000093_54873

