target=$1
pre=$2

total_lines=$(wc -l < $pre/pkgcmtslist.$target.filter3)
((lines_per_file = ($total_lines + 10 - 1) / 10))
split -l $lines_per_file -d -a 1 $pre/pkgcmtslist.$target.filter3 $pre/pkgcmtslist.$target.filter3.
for i in {0..9}; do cat $pre/pkgcmtslist.$target.filter3.$i | perl c2b2upstreams.perl $pre/regexPkgs.all 16 /data/basemaps/c2bFullF >$pre/pcbPkg.$target.$i.filter3    2>$pre/pcbPkg.$target.$i.filter3.err & done
wait
cat $pre/pcbPkg.$target.{0..9}.filter3 >$pre/pcbPkg.$target.filter3

