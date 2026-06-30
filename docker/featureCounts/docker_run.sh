#running command:
docker run --rm -v /cellfile/datapublic/ahyseni/cryption/c.elegans/:/mnt featurecounts_docker \
                /usr/local/bin/featureCounts \
                -a /mnt/data/reference_omes/filtered_transcripts.gtf \
                -f \
                -O \
                -o /mnt/docker/featureCounts/output/exon_counts.txt \
                -g transcript_id \
                -t exon \
                -p \
                -C \
                -T 8 \
                /mnt/data/BAM/K002000093_54873/Aligned.sortedByCoord.out.bam