#! /usr/bin/env python

import sys
#with open('raw/phospho_sites_STY.tsv') as file:
with open(sys.argv[1) as file:
	for line in file:
		#print line
		lst = line.strip().split('\t')
		if lst[0] == 'Proteins':
			continue
		proteins = lst[0].split(';')
		positions = lst[1].split(';')
		prob = float(lst[2])
		if prob >= 0.75:
			clas = 'I'
		elif prob <0.75 and prob >= 0.5:
			clas = 'II'
		else:
			clas = 'III'
		aa = lst[3]
		for i in range(len(proteins)):
			print "%s\t%s\t%s\t%.3f\t%s" % (proteins[i], positions[i], aa, prob, clas)
