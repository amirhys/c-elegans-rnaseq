#!/bin/bash
#SBATCH --job-name=salmon_quant
#SBATCH --output=/data/public/ahyseni/cluster/logs/salmon_quant_output_%j.out
#SBATCH --error=/data/public/ahyseni/cluster/errs/salmon_quant_error_%j.err

docker load -i "/data/public/ahyseni/cryption/c.elegans/docker/salmon_quant/salmon_quant_docker.tar"

# Run the Docker container with the FASTQ file paths passed as arguments
docker run --rm -v /data/public/ahyseni/cryption/c.elegans/data:/mnt/input_data \
                -v /data/public/ahyseni/cryption/c.elegans/docker/salmon_quant/output:/mnt/output \
                -v /data/public/ahyseni/cryption/c.elegans/docker/salmon_quant/:/mnt/salmon_quant \
                salmon_quant_docker $1 $2 $3
