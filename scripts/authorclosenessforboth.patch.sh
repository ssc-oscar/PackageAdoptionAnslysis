target=$1
target2=$2
pre=$3
#prj=$3
#prj2=$5

#python create_authorweight.py $pre/a2as.$target  $pre/a2as.$target2 >$pre/authorship_weight

#create prj -> authors list
python pkg2auslist.py $pre/pkg2atime.thatpoint.$target.s $pre/pkgAllCmtTime.output.$target.su.full >$pre/pkgauslist.$target
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/pkgauslist.$target 1 >$pre/pkgauslist.$target.filter2
python closeness_author.py  dplyrVSHmisc/authorship_weight $pre/pkgauslist.$target.filter2 >$pre/closeness_author2both.$target

python pkg2auslist.py $pre/pkg2atime.thatpoint.$target2.s $pre/pkgAllCmtTime.output.$target2.su.full >$pre/pkgauslist.$target2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 $pre/pkgauslist.$target2 1 >$pre/pkgauslist.$target2.filter2
python closeness_author.py  dplyrVSHmisc/authorship_weight $pre/pkgauslist.$target2.filter2 >$pre/closeness_author2both.$target2

