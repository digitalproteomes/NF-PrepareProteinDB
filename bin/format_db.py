#!/usr/bin/env python3

import sys
import re

def format_description(fasta_file_name):
  """
  Reformats description line of uniprot database to make TPP compatible
  >sp|P22234|PUR6_HUMAN ... -> >P22234 PUR6_HUMAN sp ...
  """
  # Match description line
  pattern = re.compile(r'^>\b(sp|tr)\b\|(\S*?)\|(\S*?) (.*)')

  formatted_fasta = ''

  with open(fasta_file_name, 'r') as fin:
    for line in fin:
      match = re.match(pattern, line)
      if match:
        formatted_fasta += ">{} {} {} {}".format(match.group(2),
                                                  match.group(3),
                                                  match.group(1),
                                                  match.group(4))
      else:
        formatted_fasta += line

  with open(fasta_file_name, 'w') as fout:
    fout.write(formatted_fasta)

fasta_file_name = sys.argv[1]
format_description(fasta_file_name)
