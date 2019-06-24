target=$1
#$pre="manupulateVSlattice"
pre=$2

for i in {0..7}; do zcat RfilesB2pkg.$i.patch.gz | grep $target | cut -d\; -f1 | sort -u | gzip> Blobs.$target.$i.patch.gz & done
wait
for i in {0..7}; do zcat Rc2b.gz | ~audris/bin/grepField.perl Blobs.$target.$i.patch.gz 2 |  gzip >Cmts2b.$target.$i.patch.gz & done
wait
cat Cmts2b.$target.{0..7}.patch.gz >Cmts2b.$target.patch.gz
zcat Cmts2b.$target.patch.gz | cut -d\; -f1 | sort -u | gzip > Cmts.$target.patch.gz

for i in {0..7}; do zcat Rc2p.$i.gz | perl ~audris/bin/grepField.perl Cmts.$target.patch.gz 1 | gzip > c2p.$target.$i.patch.gz & done
wait
cat c2p.$target.{0..7}.patch.gz > c2p.$target.patch.gz
# $target.prjs.gz
python grabpkgs.py Rprj2pkgs.1000.full $target | gzip >$target.prjs.full.gz

python filter_newBs.py $target.prjs.full.gz 1 $target.prjs.gz 1 1 | gzip>$target.prjs.patch.gz


zcat c2p.$target.patch.gz |  perl ~audris/bin/grepField.perl $target.prjs.patch.gz 2 | sort -u > cmt2prj.$target.patch

cat cmt2prj.$target.patch |  perl -I ~audris/lib64/perl5 showCmt_tune.perl 1>$pre/pkgCmtTime.output.$target 2>$pre/pkgCmtTime.output.$target.err
cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,7 | sort -t\; -n -k2,2 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su
## 2. 2 passes, 1st cmt clustering, 2nd sort by atime and each cluster only appears once.
#revise script cmt2passes.filter.py by adding in $pre on the path
cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,2,7 | sort -t\; -n -k3,3 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su.4filter2
cat $pre/pkgCmtTime.output.$target.su | cut -d\; -f1 | sort -u >$pre/pkgs.$target

cat $pre/pkgs.$target | perl /da3_data/lookup/Prj2CmtShow.perl /data/basemaps/Prj2CmtG 1 8 1>$pre/pkg2cmts.output.$target 2>$pre/pkg2cmts.$target.err

cat $pre/pkgCmtTime.output.$target.su | python filterout_firsttime_pkg2atime.py >$pre/pkg2atime.thatpoint.$target 2>$pre/pkg2atime.thatpoint.$target.err
cat $pre/pkg2cmts.output.$target | python cmt2pkg2atime.py 2>$pre/cmt2pkg2atime.$target.err | perl -I ~audris/lib64/perl5 showCmt_tune2.perl 1>$pre/pkgAllCmtTime.output.$target 2>$pre/pkgAllCmtTime.output.$target.err

cat $pre/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | sort -t\; -n -k4,4 | uniq | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su
cat $pre/pkgAllCmtTime.output.$target dplyrVSHmisc/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | sort -t\; -n -k4,4 | uniq | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su.full



python numofCMTsAusuptothatPoint.py $pre/pkg2atime.thatpoint.$target $pre/pkgAllCmtTime.output.$target.su >$pre/numofCMTsAusuptothatPoint.$target 2>$pre/numofCMTsAusuptothatPoint.$target.err

cat $pre/pkg2atime.thatpoint.$target dplyrVSHmisc/pkg2atime.thatpoint.$target | sort -t\; -n -k2,2 >$pre/pkg2atime.thatpoint.$target.s
python numofPrjsAcuRec.py $pre/pkg2atime.thatpoint.$target.s 1>$pre/numofPrjsAcuRec.$target 2>$pre/numofPrjsAcuRec.$target.err

#now applying excluding forks
# this need to be fixed for patch
cat $pre/pkgCmtTime.output.$target.su.4filter2 dplyrVSHmisc/pkgCmtTime.output.$target.su.4filter2 >$pre/pkgCmtTime.output.$target.su.4filter2.patch
python cmt2passes.filter.intermedia.py $pre/pkgCmtTime.output.$target.su.4filter2.patch 1>$pre/pkg2atime.filter2.thatpoint.$target 2>$pre/pkg2atime.filter2.thatpoint.$target.err
python numofPrjsAcuRec.py $pre/pkg2atime.filter2.thatpoint.$target 1>$pre/numofPrjsAcuRec.filter2.$target 2>$pre/numofPrjsAcuRec.filter2.$target.err
cat $pre/numofCMTsAusuptothatPoint.$target dplyrVSHmisc/numofCMTsAusuptothatPoint.$target > $pre/numofCMTsAusuptothatPoint.$target.full
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/numofCMTsAusuptothatPoint.$target.full 1 >$pre/numofCMTsAusuptothatPoint.$target.filter2

