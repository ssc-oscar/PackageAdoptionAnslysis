#!/bin/bash

pre="/data/basemaps"
: <<'END'
for i in {0..7}; do gunzip -c $pre/f2cFullF.$i.lst | grep -i '\.r;' | cut -d\; -f1 | gzip > Rfiles.$i.gz & done
wait
for i in {0..7}; do gunzip -c $pre/gz/f2cFullF$i.s | ~audris/bin/grepField.perl Rfiles.$i.gz 1 | gzip > Rf2c.$i.gz & done
wait
for i in {0..7}; do zcat Rf2c.$i.gz |  cut -d\; -f2- | sed 's/\;/\n/g' |  gzip > RfilesC.$i.gz & done
wait
for i in {0..7}; do gunzip -c RfilesC.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl RfilesCU. 8
wait


for i in {0..7}; do gunzip -c $pre/gz/Cmt2PrjG$i.s |  ~audris/bin/grepField.perl RfilesCU.$i.gz 1 | gzip > Rc2p.$i.gz & done
wait
for i in {0..7}; do zcat Rc2p.$i.gz | cut -d\; -f2- | perl -ane 's/\;/\n/g;print' | gzip > RfilesP.$i.gz & done
wait
for i in {0..7}; do gunzip -c RfilesP.$i.gz; done | lsort 20G -u | gzip > RfilesP.gz
wait


for i in {0..7}; do gunzip -c RfilesC.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl RfilesC4BU. 16
wait
for i in {0..15}; do gunzip -c $pre/gz/c2bFullF$i.gz |  ~audris/bin/grepField.perl RfilesC4BU.$i.gz 1 | gzip > Rc2b.$i.gz & done
wait

for i in {0..15}; do zcat Rc2b.$i.gz |  cut -d\; -f2- | sed 's/\;/\n/g' |  gzip > RfilesBB.$i.gz & done
wait
for i in {0..15}; do gunzip -c RfilesBB.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl RfilesB. 8 
wait

# the latter one needs to be tested before being used
for i in {0..7}; do  zcat RfilesB.$i.gz |  perl b2pkgs.perl | gzip >RfilesB2pkg.$i.gz & done
wait
cat RfilesB2pkg.{0..7}.gz >RfilesB2pkg.gz
# commit 2 pkgs
for i in {0..15}; do gunzip -c  Rc2b.$i.gz | python  cmt2pkgsR.py  RfilesB2pkg.gz | gzip > Rc2pkg.$i.gz & done
wait
cat Rc2pkg.{0..15}.gz > Rc2pkg.gz
END
# prj 2 pkgs
for i in {0..7}; do gunzip -c  Rc2p.$i.gz | python  prj2pkgsR.py  Rc2pkg.gz | gzip > Rprj2pkg.$i.gz & done
wait
cat Rprj2pkg.{0..7}.gz > Rprj2pkg.gz
#merge on prjs
zcat Rprj2pkg.gz | python mergeprjsR.py | gzip >Rprj2pkg.U.gz



#produce a list of addiitional projects that have at least one .py file
#gunzip -c pyfilesP.gz | sed 's|_|/|' | lsort 10G -u | join -v1 - <(cat /da0_data/github/list2018.* |cut -d\; -f1 | lsort 10G -u) > /da0_data/github/list2018.pyOld
