int year = Calendar.getInstance().get(Calendar.YEAR)
int month = Calendar.getInstance().get(Calendar.MONTH)+1
time_stamp = year + "_" + String.format("%02d", month)
db_name = time_stamp + "_" + params.up_id

if(params.help) {
    log.info""
    log.info"Prepare UniProt DB"
    log.info"----------------------------"
    log.info""
    log.info"Options:"
    log.info "  --help:         show this message and exit"
    log.info "  --up_id:        the UniProt ID of the proteome (default: UP000005640)"
    log.info "  --reviewed:     only include reviewed entries (default: yes)"
    log.info "  --decoy:        prefix for decoys (default: DECOY_)"
    log.info ""
    log.info "Results will be in Results/Mzxml/"
    log.info ""
    exit 1
}

process download {
    output:
    file("${db_name}.fasta")  into download_out

    script:
    """
    wget -O - 'https://www.uniprot.org/uniprot/?query=proteome:$params.up_id%20reviewed:${params.reviewed}&format=fasta&force=true&compress=yes' | gunzip -c > ${db_name}.fasta
    """
}


process formatForTpp {
    input:
    file fasta from download_out

    output:
    file("${db_name}.fasta") into format_out
    
    script:
    """
    format_db.py $fasta
    """
}


process generateDecoys {
    publishDir 'Results'
    
    input:
    file fasta from format_out

    output:
    file("${db_name}_decovy.fasta")
    
    script:
    "decoyFastaGenerator.pl $fasta $params.decoy ${db_name}_decovy.fasta"
}
