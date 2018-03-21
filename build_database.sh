# add software to PATH
module add fastxtoolkit/0.0.13
module add bedtools/2.25.0

# get the header of raw table
head -1 raw/Phospho\ \(STY\)Sites\ \(2\).txt |tr '\t' '\n' > raw/header

# manually check the raw table and comment the required columns in header file

# select columns
grep -n '#' raw/header 
cut -f1,2,6,30 raw/Phospho\ \(STY\)Sites\ \(2\).txt | grep '^AT' > raw/phospho_sites_STY.tsv

# clean the raw table
mkdir clean
./script/clean_table.py raw/phospho_sites_STY.tsv|sort|uniq > clean/phospho_sites_STY.tsv

# add window sequence
mkdir TAIR10
wget ftp://ftp.arabidopsis.org/home/tair/Proteins/TAIR10_protein_lists/TAIR10_pep_20101214 -O TAIR10/TAIR10_pep_20101214.fa
fasta_formatter -t -i TAIR10/TAIR10_pep_20101214.fa|sed -r 's/ \|.+\t/\t/'|sort|uniq > clean/TAIR10_protein_seq.tab
cat clean/TAIR10_protein_seq.tab|awk -F "\t" '{print $1"\t_______________"$2"_______________"}' > clean/TAIR10_protein_seq_extend15.tab
./script/get_seq_window.py clean/phospho_sites_STY.tsv > clean/phospho_sites_STY_window.tsv

# protein information tables 
wget ftp://ftp.arabidopsis.org/home/tair/Genes/gene_aliases_20140331.txt -O TAIR10/gene_aliases_20140331.txt
wget ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_functional_descriptions_20140331.txt -O TAIR10/TAIR10_functional_descriptions_20140331.txt
wget ftp://ftp.arabidopsis.org/home/tair/Proteins/Domains/TAIR10_all.domains -O TAIR10/TAIR10_all.domains
wget ftp://ftp.arabidopsis.org/home/tair/Ontologies/Gene_Ontology/ATH_GO_GOSLIM.txt -O TAIR10/ATH_GO_GOSLIM.txt

grep '^AT[1-5CM]G' TAIR10/gene_aliases_20140331.txt|cut -f1,2|sort -k1,1 -k2,2|uniq|grep -v '#'|groupBy -g 1 -c 2 -o collapse > clean/TAIR10_gene_aliases.tsv
grep '^AT[1-5CM]G' TAIR10/TAIR10_functional_descriptions_20140331.txt |cut -f1-3|sed 's/&#64257;/fi/' > clean/TAIR10_functional_descriptions.tsv
cut -f1,4,6-8 TAIR10/TAIR10_all.domains|grep 'HMMPfam' > clean/TAIR10_all.domains.HMMPfam.tsv
grep '^AT[1-5CM]G' TAIR10/ATH_GO_GOSLIM.txt|cut -f1,5,6,8|sort|uniq > clean/TAIR10_GO.tsv

# create headers
echo -e "psiteID\tproteinID\tgeneID\tposition\tamino_acid\tprobability\tclass\twindow" > clean/phospho_sites_STY_window.header
echo -e "geneID\taliase" > clean/TAIR10_gene_aliases.header
echo -e "proteinID\tbiotype\tdescription" > clean/TAIR10_functional_descriptions.header
echo -e "proteinID\tsource\tdomain\tstart\tend" > clean/TAIR10_all.domains.HMMPfam.header
echo -e "geneID\tGO_term\tGO_accession\tGO_domain" > clean/TAIR10_GO.header

# load into sqlite database
./script/tsv2sqlite.py clean/phospho_sites_STY_window.tsv test.db psites --headers clean/phospho_sites_STY_window.header
./script/tsv2sqlite.py clean/TAIR10_gene_aliases.tsv test.db aliases --headers clean/TAIR10_gene_aliases.header
./script/tsv2sqlite.py clean/TAIR10_functional_descriptions.tsv test.db descriptions --headers clean/TAIR10_functional_descriptions.header
./script/tsv2sqlite.py clean/TAIR10_all.domains.HMMPfam.tsv test.db domains --headers clean/TAIR10_all.domains.HMMPfam.header
./script/tsv2sqlite.py clean/TAIR10_GO.tsv test.db GO --headers clean/TAIR10_GO.header
