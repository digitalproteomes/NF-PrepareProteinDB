# Nextflow workflow for downloading and preparing fasta proteome databases from UniProt

This workflow downloads a protein fasta database from UniProt; reformats the descriptions for TPP; and adds decoys. 
Optionally a local database can also be used as a starting point.

## Usage

The workflow takes the following parameters:
* --remote:       whether to download database from UniProt (true) or use local one (false)	
* --up_id:        the UniProt ID of the proteome (default: UP000005640)
* --decoy:        prefix for decoys (default: DECOY_). Set to false to skip decoy generation
* --local_database: path to local database (in combination with remote = false)a

Example usage:

```bash
nextflow run digitalproteomes/NF-PrepareProteinDB
```
At the end of the workflow the prepared database will be found in the *Results/Databases* folder. 
For convenience the database will also be symlinked as proteome.fasta
