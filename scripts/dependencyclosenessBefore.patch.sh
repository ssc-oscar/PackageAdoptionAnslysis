target=$1
target2=$2
pre=$3

#up dependency of each project, calculating the score
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target.s $pre/pkgAllCmtTime.output.$target.su >$pre/pkgcmtslist.$target
python pkg2cmtslist.py $pre/pkg2atime.thatpoint.$target2.s $pre/pkgAllCmtTime.output.$target2.su >$pre/pkgcmtslist.$target2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/pkgcmtslist.$target 1 >$pre/pkgcmtslist.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 $pre/pkgcmtslist.$target2 1 >$pre/pkgcmtslist.$target2.filter2

