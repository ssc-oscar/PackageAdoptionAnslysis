target=$1
target2=$2
pre=$3

python datatabletidyDepends.py ../libraries.io.depens/R_META_CRAN_downstream_direct_noV $target >layeddownstreams.$target
python datatabletidyDepends.py ../libraries.io.depens/R_META_CRAN_downstream_direct_noV $target2 >layeddownstreams.$target2
#Once for all
python statisticOflayedDowns.py layeddownstreams.$target layeddownstreams.$target2 ../libraries.io.depens/R_META_CRAN_downstream_direct_noV $pre/dependenciesweight >layeddownstreams.statistics.$pre 2>HotspotsDownstreams


# the number need to be addressed
tail -n $(expr $(wc -l layeddownstreams.$target | cut -d' ' -f1) - 1) layeddownstreams.$target |sed 's/,/\n/g'| sort -u  | python create_regexs.py >$pre/regexPkgs.$target
tail -n $(expr $(wc -l layeddownstreams.$target2 | cut -d' ' -f1) - 1) layeddownstreams.$target2 |sed 's/,/\n/g'| sort -u  | python create_regexs.py >$pre/regexPkgs.$target2
cat $pre/regexPkgs.$target $pre/regexPkgs.$target2 | sort -u >$pre/regexPkgs.all

#up dependency of each project, calculating the score
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target.s $pre/pkgAllCmtTime.output.$target.su >$pre/pkgcmtslist.$target
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target2.s $pre/pkgAllCmtTime.output.$target2.su >$pre/pkgcmtslist.$target2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/pkgcmtslist.$target 1 >$pre/pkgcmtslist.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 $pre/pkgcmtslist.$target2 1 >$pre/pkgcmtslist.$target2.filter2





#the following is very slow, might need to change by using pkgcmtslist.$target.filter2 with c2b b2pkgs
# I'm using multi-threading, split into 10 pieces, reduce time to 1/10
total_lines=$(wc -l < $pre/pkgcmtslist.$target.filter2)
((lines_per_file = ($total_lines + 10 - 1) / 10))
split -l $lines_per_file -d -a 1 $pre/pkgcmtslist.$target.filter2 $pre/pkgcmtslist.$target.filter2.
for i in {0..9}; do cat $pre/pkgcmtslist.$target.filter2.$i | perl c2b2upstreams.perl $pre/regexPkgs.all 16 /data/basemaps/c2bFullF >$pre/pcbPkg.$target.$i    2>$pre/pcbPkg.$target.$i.err & done
wait
cat $pre/pcbPkg.$target.{0..9} >$pre/pcbPkg.$target





#cat $pre/pkgcmtslist.$target2.filter2 | perl c2b2upstreams.perl $pre/regexPkgs.all 16 /data/basemaps/c2bFullF >$pre/pcbPkg.$target2   2>$pre/pcbPkg.$target2.err
python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target >$pre/closeness2both.$target
python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target2 >$pre/closeness2both.$target2
