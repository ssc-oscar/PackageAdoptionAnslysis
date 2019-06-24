target=$1
pre=$2
ecosys=$3

total_lines=$(wc -l < $pre/pkgcmtslist.$target.filter2)
((lines_per_file = ($total_lines + 10 - 1) / 10))
split -l $lines_per_file -d -a 1 $pre/pkgcmtslist.$target.filter2 $pre/pkgcmtslist.$target.filter2.
#merge p2c, c2b, b2pkg
#cat $ecosys/jsonc2b.{0..15}.gz >$ecosys/jsonc2b.gz
for i in {0..9}
do
 python Merge_4.py $pre/pkgcmtslist.$target.filter2.$i $ecosys/jsonc2b.gz $ecosys/jsonfilesB2pkg.gz >$pre/pcbPkg.$target.$i 2>$pre/Merge_4.$i.err &
done
wait

#Maybe later, need to grep from real blob content, not just from package.json blobs.
#for i in {0..15}; do gunzip -c  jsonc2b.$i.gz | python  cmt2pkgsR.py  jsonfilesB2pkg.gz | gzip > jsonc2pkg.$i.gz & done
#wait
#cat $pre/pkgcmtslist.$target.filter2.$i | perl c2b2upstreams.perl $pre/regexPkgs.all 16 /data/basemaps/c2bFullF >$pre/pcbPkg.$target.$i    2>$pre/pcbPkg.$target.$i.err & done
#wait

cat $pre/pcbPkg.$target.{0..9} >$pre/pcbPkg.$target

