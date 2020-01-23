# Nextflow workflow for downloading and preparing fasta proteome databases from UniProt

This workflow downloads a protein fasta database from UniProt; reformats the descriptions for TPP; and adds decoys.

## Usage

The workflow takes the following parameters:
* --help:         show this message and exit
* --up_id:        the UniProt ID of the proteome (default: UP000005640)
* --reviewed:     only include reviewed entries (default: yes)
* --decoy:        prefix for decoys (default: DECOY_)

Example usage:

```bash
nextflow run digitalproteomes/NF-PrepareProteinDB
```
At the end of the workflow the prepared database will be found in the *Results/Databases* folder.
