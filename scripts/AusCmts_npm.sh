target=$1
#$pre="manupulateVSlattice"
pre=$2
ecosys=$3

for i in {0..7}; do zcat $ecosys/jsonfilesB2pkg.$i.gz | grep $target | cut -d\; -f1 | sort -u | gzip> $pre/Blobs.$target.$i.gz & done
wait
for i in {0..7}; do zcat $ecosys/jsonc2b.gz | ~audris/bin/grepField.perl $pre/Blobs.$target.$i.gz 2 |  gzip >$pre/Cmts2b.$target.$i.gz & done
wait
cat $pre/Cmts2b.$target.{0..7}.gz >$pre/Cmts2b.$target.gz
zcat $pre/Cmts2b.$target.gz | cut -d\; -f1 | sort -u | gzip > $pre/Cmts.$target.gz

for i in {0..7}; do zcat $ecosys/jsonc2p.$i.gz | perl ~audris/bin/grepField.perl $pre/Cmts.$target.gz 1 | gzip > $pre/c2p.$target.$i.gz & done
wait
cat $pre/c2p.$target.{0..7}.gz > $pre/c2p.$target.gz
# $target.prjs.gz
python grabpkgs.py $ecosys/jsonprj2pkgs.1000 $target | gzip >$pre/$target.prjs.gz
zcat $pre/c2p.$target.gz |  perl ~audris/bin/grepField.perl $pre/$target.prjs.gz 2 | sort -u > $pre/cmt2prj.$target

cat $pre/cmt2prj.$target |  perl -I ~audris/lib64/perl5 showCmt_tune.perl 1>$pre/pkgCmtTime.output.$target 2>$pre/pkgCmtTime.output.$target.err
cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,7 | sort -t\; -n -k2,2 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su
## 2. 2 passes, 1st cmt clustering, 2nd sort by atime and each cluster only appears once.
#revise script cmt2passes.filter.py by adding in $pre on the path
cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,2,7 | sort -t\; -n -k3,3 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su.4filter2
cat $pre/pkgCmtTime.output.$target.su | cut -d\; -f1 | sort -u >$pre/pkgs.$target

cat $pre/pkgs.$target | perl /da3_data/lookup/Prj2CmtShow.perl /data/basemaps/Prj2CmtH 1 8 1>$pre/pkg2cmts.output.$target 2>$pre/pkg2cmts.$target.err

cat $pre/pkgCmtTime.output.$target.su | python filterout_firsttime_pkg2atime.py >$pre/pkg2atime.thatpoint.$target 2>$pre/pkg2atime.thatpoint.$target.err
cat $pre/pkg2cmts.output.$target | python cmt2pkg2atime.py 2>$pre/cmt2pkg2atime.$target.err | perl -I ~audris/lib64/perl5 showCmt_tune2.perl 1>$pre/pkgAllCmtTime.output.$target 2>$pre/pkgAllCmtTime.output.$target.err

cat $pre/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su
#cat $pre/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | lsort 200G -t\; -n -k4,4 | uniq | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su
python numofCMTsAusuptothatPoint.py $pre/pkg2atime.thatpoint.$target $pre/pkgAllCmtTime.output.$target.su >$pre/numofCMTsAusuptothatPoint.$target 2>$pre/numofCMTsAusuptothatPoint.$target.err

cat $pre/pkg2atime.thatpoint.$target | sort -t\; -n -k2,2 >$pre/pkg2atime.thatpoint.$target.s
python numofPrjsAcuRec.py $pre/pkg2atime.thatpoint.$target.s 1>$pre/numofPrjsAcuRec.$target 2>$pre/numofPrjsAcuRec.$target.err
#now applying excluding forks
python cmt2passes.filter.intermedia.py $pre/pkgCmtTime.output.$target.su.4filter2 1>$pre/pkg2atime.filter2.thatpoint.$target 2>$pre/pkg2atime.filter2.thatpoint.$target.err

python allforks.filter.py $pre/pkgCmtTime.output.$target.su.4filter2 /data/basemaps/gz/c2pFullI.forks 1>$pre/pkg2atime.filter3.thatpoint.$target.dirty 2>$pre/pkg2atime.filter3.thatpoint.$target.dirty.err

python numofPrjsAcuRec.py $pre/pkg2atime.filter2.thatpoint.$target 1>$pre/numofPrjsAcuRec.filter2.$target 2>$pre/numofPrjsAcuRec.filter2.$target.err
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/numofCMTsAusuptothatPoint.$target 1 >$pre/numofCMTsAusuptothatPoint.$target.filter2

