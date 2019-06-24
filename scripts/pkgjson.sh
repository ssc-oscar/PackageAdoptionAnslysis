#!/bin/bash

pre="/data/basemaps"
dir="pkgjson"
cd $dir
:<<"END"
for i in {0..7}; do gunzip -c $pre/f2cFullF.$i.lst | grep -i 'package.json' | cut -d\; -f1 | gzip > jsonfiles.$i.gz & done
#for i in {0..7}; do zcat /data/basemaps/gz/f2cFullF$i.s | grep 'package.json' | gzip >package.json.$i & done
#wait
#zcat package.json.{0..7} | cut -d\, -f2 | lsort 10G -u | /da3_data/lookup/splitSec.perl $dir/fcpkg.json. 16
#for i in {0..15}; do  zcat $dir/fcpkg.json.$i.gz | perl extr_stms_f2c2b.perl /data/basemaps/c2bFullF 16 2>$dir/c2b.$i.err | gzip >$dir/c2b.$i.gz & done
#wait
for i in {0..7}; do gunzip -c $pre/gz/f2cFullF$i.s | ~audris/bin/grepField.perl jsonfiles.$i.gz 1 | gzip > jsonf2c.$i.gz & done
wait
for i in {0..7}; do zcat jsonf2c.$i.gz |  cut -d\; -f2- | sed 's/\;/\n/g' |  gzip > jsonfilesC.$i.gz & done
wait
for i in {0..7}; do gunzip -c jsonfilesC.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl jsonfilesCU. 8
wait


for i in {0..7}; do gunzip -c $pre/gz/Cmt2PrjH$i.s |  ~audris/bin/grepField.perl jsonfilesCU.$i.gz 1 | gzip > jsonc2p.$i.gz & done
wait
for i in {0..7}; do zcat jsonc2p.$i.gz | cut -d\; -f2- | perl -ane 's/\;/\n/g;print' | gzip > jsonfilesP.$i.gz & done
wait
for i in {0..7}; do gunzip -c jsonfilesP.$i.gz; done | lsort 20G -u | gzip > jsonfilesP.gz
wait


for i in {0..7}; do gunzip -c jsonfilesC.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl jsonfilesC4BU. 16
wait
for i in {0..15}; do gunzip -c $pre/gz/c2bFullF$i.gz |  ~audris/bin/grepField.perl jsonfilesC4BU.$i.gz 1 | gzip > jsonc2b.$i.gz & done
wait
cat jsonc2b.{0..15}.gz >jsonc2b.gz
for i in {0..15}; do zcat jsonc2b.$i.gz |  cut -d\; -f2- | sed 's/\;/\n/g' |  gzip > jsonfilesBB.$i.gz & done
wait
for i in {0..15}; do gunzip -c jsonfilesBB.$i.gz; done | lsort 20G -u | /da3_data/lookup/splitSec.perl jsonfilesB. 8 
wait
# the latter one needs to be tested before being used, this is problematic, cause commit may change other files tha are not package.json
for i in {0..7}; do  zcat jsonfilesB.$i.gz |  perl ../b2pkgs4npm.perl | gzip >jsonfilesB2pkg.$i.gz & done
wait
cat jsonfilesB2pkg.{0..7}.gz >jsonfilesB2pkg.gz
#sstop here to see if empty dependencies exists in jsonfilesB2pkg.gz, if yes, then modify cmt2pkgsR.py
# commit 2 pkgs
END
for i in {0..15}; do gunzip -c  jsonc2b.$i.gz | python  ../cmt2pkgsNPM.py  jsonfilesB2pkg.gz | gzip > jsonc2pkg.$i.gz & done
wait
cat jsonc2pkg.{0..15}.gz > jsonc2pkg.gz

# prj 2 pkgs
for i in {0..7}; do gunzip -c  jsonc2p.$i.gz | python  ../prj2pkgsR.py  jsonc2pkg.gz | gzip > jsonprj2pkg.$i.gz & done
wait
cat jsonprj2pkg.{0..7}.gz > jsonprj2pkg.gz
#merge on prjs
zcat jsonprj2pkg.gz | python ../mergeprjsR.py | gzip >jsonprj2pkg.U.gz
#need a filter here to filter out the garbage, then:
zcat jsonprj2pkg.U.gz | python ../seekingparis.py >jsonprj2pkgs.1000


#produce a list of addiitional projects that have at least one .py file
#gunzip -c pyfilesP.gz | sed 's|_|/|' | lsort 10G -u | join -v1 - <(cat /da0_data/github/list2018.* |cut -d\; -f1 | lsort 10G -u) > /da0_data/github/list2018.pyOld
