for i in {0..7}; do python filter_newBs.py RfilesB.$i.gz 1 RfilesB2pkg.$i.gz 1 1 | perl b2pkgs.perl  2>b2pkg.patch.$i.err | gzip >RfilesB2pkg.$i.patch.gz & done
wait

for i in {0..7}; do cat RfilesB2pkg.$i.patch.gz RfilesB2pkg.$i.gz > RfilesB2pkg.$i.gz.full & done
wait

cat RfilesB2pkg.{0..7}.patch.gz >RfilesB2pkg.patch.gz
#looks like we only need up to this step for dplyr/Hmisc

# commit 2 pkgs
for i in {0..15}; do gunzip -c  Rc2b.$i.gz | python  cmt2pkgsR.py  RfilesB2pkg.patch.gz | gzip > Rc2pkg.$i.patch.gz & done
wait

#problem: how to merge these... cmt2pkg.patch may have shared commit with non patch, right?Yes, may have duplicate commits. keep in mind.
cat Rc2pkg.{0..15}.patch.gz > Rc2pkg.patch.gz

# prj 2 pkgs
for i in {0..7}; do gunzip -c  Rc2p.$i.gz | python  prj2pkgsR.py  Rc2pkg.patch.gz | gzip > Rprj2pkg.$i.patch.gz & done
wait

cat Rprj2pkg.{0..7}.patch.gz > Rprj2pkg.patch.gz

#merge on prjs
zcat Rprj2pkg.gz Rprj2pkg.patch.gz | python mergeprjsR.py | gzip >Rprj2pkg.U.full.gz

zcat Rprj2pkg.U.full.gz | python clean_Rprjs2pkgs.py >Rprj2pkg.U.clean.full
cat Rprj2pkg.U.clean.full | python seekingparis.py >Rprj2pkgs.1000.full


# I utilized RfilesB2pkg.$i.gz; Rprj2pkgs.1000
