//////////////////////////
// Workflow definitions //
//////////////////////////


include {generateDbName;
	 uniprotDownload;
	 formatForTpp;
	 generateDecoys;
	 symLinkDb} from './prepareProteinDB_processes.nf'


workflow remote {
    // Downloads and preps a database from UniProt

    take:
    up_id
    decoy_prefix

    main:
    generateDbName(up_id)
    uniprotDownload(up_id,
		    generateDbName.out.db_name)
    formatForTpp(uniprotDownload.out.database)
    if(decoy_prefix){
	generateDecoys(formatForTpp.out.database,
		       decoy_prefix,
		       generateDbName.out.db_name)
	symLinkDb(generateDecoys.out.database)
    }
    else {
	symLinkDb(uniprotDownload.out.database)
    }
}


workflow local {
    take:
    local_database
    decoy_prefix

    main:
    formatForTpp(file(local_database))
    if(decoy_prefix) {
	generateDecoys(formatForTpp.out.database,
		       decoy_prefix,
		       file(local_database).simpleName)
	symLinkDb(generateDecoys.out.database)
    }
    else {
	symLinkDb(uniprotDownload.out.database)
    }
}
