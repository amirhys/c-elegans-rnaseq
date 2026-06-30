import os

samples = [
    ("K002000093_54873", "wt"),
    ("K002000093_54875", "wt"),
    ("K002000093_54877", "wt"),
    ("K002000093_54879", "ama1"),
    ("K002000093_54881", "ama1"),
    ("K002000093_54883", "ama1"),
    ("K002000093_54885", "daf2"),
    ("K002000093_54887", "daf2"),
    ("K002000093_54889", "daf2"),
    ("K002000244_89704", "wtday1"),
    ("K002000244_89706", "wtday1"),
    ("K002000244_89708", "wtday1"),
    ("K002000244_89710", "ama1day1"),
    ("K002000244_89712", "ama1day1"),
    ("K002000244_89714", "ama1day1"),
]

# Path to the SLURM template file
slurm_file = "salmon_quant.slurm"

# Path to where the generated submission script will be saved
output_sh = "submit_all_jobs.sh"

with open(output_sh, "w") as f:
    f.write("#!/bin/bash\n\n")
    
    # Loop through the samples and add sbatch commands for each
    for sample_id, sample_type in samples:
        fastq1 = f"/mnt/input_data/FASTQ/{sample_id}/R1.fastq.gz"
        fastq2 = f"/mnt/input_data/FASTQ/{sample_id}/R2.fastq.gz"
        output_dir = f"/mnt/output/{sample_type}/{sample_id}"
        
        # Add command to create output directory
        f.write(f"mkdir -p /data/public/ahyseni/cryption/c.elegans/docker/salmon_quant/output/{sample_type}/{sample_id}\n")
        
        # Add sbatch command
        f.write(f"sbatch {slurm_file} {fastq1} {fastq2} {output_dir}\n\n")

# Make the generated shell script executable
os.chmod(output_sh, 0o755)
