#! /usr/bin/env python

import sys

proteins = {}
extend = 15

with open('clean/TAIR10_protein_seq_extend15.tab') as f:
	for line in f:
		ID, seq = line.strip().split('\t')
		proteins[ID] = seq

with open(sys.argv[1]) as f:
#with open('clean/phospho_sites_STY.tsv') as f:
	for line in f:
		lst = line.strip().split('\t')
		ID = lst[0]
		pos = lst[1]
		aa = lst[2]
		prob = lst[3]
		clas = lst[4]
		seq = proteins[ID]

		i = int(pos) + extend - 1 

		if aa != seq[i]:
			print ID + '\t' + pos + '\t' + aa + '\t' + seq[i]

		window = seq[i-extend:i+extend+1]
		siteID = ID + '_' + pos
		gene = ID.split('.')[0]
		print "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s" % (siteID, ID, gene, pos, aa, prob, clas, window)
