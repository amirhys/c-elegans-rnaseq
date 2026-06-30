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

with open('run_all_dockers.sh', 'w') as f:
    for sample_id, sample_type in samples:
        f.write(f'mkdir -p /cellfile/datapublic/ahyseni/cryption/c.elegans/docker/featureCounts/output/{sample_type}/{sample_id} \n')
        f.write(f'docker run --rm -v /cellfile/datapublic/ahyseni/cryption/c.elegans/:/mnt featurecounts_docker \\\n')
        f.write(f'          /usr/local/bin/featureCounts \\\n')
        f.write(f'          -a /mnt/data/reference_omes/Caenorhabditis_elegans.WBcel235.90.gtf \\\n')
        f.write(f'          -f -O -p -C -T 8 -g transcript_id \\\n')
        f.write(f'          -o /mnt/docker/featureCounts/output/{sample_type}/{sample_id}/exon_counts.txt \\\n')
        f.write(f'          /mnt/data/BAM/{sample_id}/Aligned.sortedByCoord.out.bam \n\n\n')

