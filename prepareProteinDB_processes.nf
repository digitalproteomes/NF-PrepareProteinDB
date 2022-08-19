process generateDbName {
    // Returns a time_stamped name for a UniProt protein database with
    // UniProt ID up_id
    tag "$up_id"
    
    input:
    val up_id

    output:
    val db_name, emit: db_name

    exec:
    int year = Calendar.getInstance().get(Calendar.YEAR)
    int month = Calendar.getInstance().get(Calendar.MONTH)+1
    time_stamp = year + "_" + String.format("%02d", month)
    db_name = time_stamp + "_" + up_id
}


process uniprotDownload {
    tag "$db_name"
    
    input:
    val up_id
    val db_name
    
    output:
    path '*.fasta', emit: database

    script:
    """
    wget -O - 'https://rest.uniprot.org/uniprotkb/stream?compressed=true&format=fasta&query=%28proteome%3A$up_id%29' | gunzip -c > ${db_name}.fasta
    """
}


process formatForTpp {
    tag "$db_name"

    publishDir 'Results/Databases', mode: 'link'
    
    input:
    file database

    output:
    path database, emit: database
    
    script:
    """
    format_db.py $database
    """
}


process generateDecoys {
    tag "$db_name"
    
    publishDir 'Results/Databases', mode: 'link'
    
    input:
    file database
    val decoy_prefix
    val db_name

    output:
    path '*_decoy.fasta', emit: database
    
    script:
    "decoyFastaGenerator.pl $database $decoy_prefix ${db_name}_decoy.fasta"
}


process symLinkDb {
    tag "$database"

    input:
    file database

    script:
    """
    ln -rsf $workflow.launchDir/Results/Databases/$database $workflow.launchDir/Results/Databases/proteome.fasta
    """
}
