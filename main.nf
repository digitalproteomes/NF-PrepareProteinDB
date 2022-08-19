nextflow.enable.dsl=2

include {remote;
	 local} from './prepareProteinDB_workflows.nf'

//     log.info ""
//     exit 1
// }


workflow {
    main:
    log.info("++++++++++========================================")
    log.info("Executing PrepareProteinDB workflow")
    log.info("")
    log.info("Parameters:")
    if(params.remote) {
	log.info(" Uniprot ID:\t $params.up_id")
    }
    else {
	log.info(" Input database:\t $params.local_database")
    }
    if(params.decoy_prefix){
	log.info(" Decoy prefix:\t $params.decoy_prefix")
    }
    log.info("++++++++++========================================")


    if(params.remote) {
	remote(params.up_id,
	       params.decoy_prefix)
    }
    else {
	local(params.local_database,
	      params.decoy_prefix)
    }    
}
