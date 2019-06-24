target=$1
target2=$2
pre=$3


python npm_downstream_direct_noV.py /data/play/eco-network/folder4permission/npm_layered_dependency_npms.npms_all_20180517 1>$pre/downstream_direct_noV 2>$pre/downstream_direct_noV.err
python datatabletidyDepends.py $pre/downstream_direct_noV $target >$pre/layeddownstreams.$target
python datatabletidyDepends.py $pre/downstream_direct_noV $target2 >$pre/layeddownstreams.$target2
#Once for all
python statisticOflayedDowns.py $pre/layeddownstreams.$target $pre/layeddownstreams.$target2 $pre/downstream_direct_noV $pre/dependenciesweight >$pre/layeddownstreams.statistics.$pre 2>$pre/HotspotsDownstreams


# the number need to be addressed
tail -n $(expr $(wc -l $pre/layeddownstreams.$target | cut -d' ' -f1) - 1) $pre/layeddownstreams.$target |sed 's/,/\n/g'| sort -u  | python create_regexs.py >$pre/regexPkgs.$target
tail -n $(expr $(wc -l $pre/layeddownstreams.$target2 | cut -d' ' -f1) - 1) $pre/layeddownstreams.$target2 |sed 's/,/\n/g'| sort -u  | python create_regexs.py >$pre/regexPkgs.$target2
cat $pre/regexPkgs.$target $pre/regexPkgs.$target2 | sort -u >$pre/regexPkgs.all

#up dependency of each project, calculating the score
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target.s $pre/pkgAllCmtTime.output.$target.su >$pre/pkgcmtslist.$target
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target2.s $pre/pkgAllCmtTime.output.$target2.su >$pre/pkgcmtslist.$target2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/pkgcmtslist.$target 1 >$pre/pkgcmtslist.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 $pre/pkgcmtslist.$target 1 >$pre/pkgcmtslist.$target.filter3
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 $pre/pkgcmtslist.$target2 1 >$pre/pkgcmtslist.$target2.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target2 1 $pre/pkgcmtslist.$target2 1 >$pre/pkgcmtslist.$target2.filter3

