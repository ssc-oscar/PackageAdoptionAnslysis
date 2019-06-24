target=$1
#$pre="manupulateVSlattice"
pre=$2

#for i in {0..7}; do zcat RfilesB2pkg.$i.gz | grep $target | cut -d\; -f1 | sort -u | gzip> Blobs.$target.$i.gz & done
#wait
#for i in {0..7}; do zcat Rc2b.gz | ~audris/bin/grepField.perl Blobs.$target.$i.gz 2 |  gzip >Cmts2b.$target.$i.gz & done
#wait
#cat Cmts2b.$target.{0..7}.gz >Cmts2b.$target.gz
#zcat Cmts2b.$target.gz | cut -d\; -f1 | sort -u | gzip > Cmts.$target.gz
#
#for i in {0..7}; do zcat Rc2p.$i.gz | perl ~audris/bin/grepField.perl Cmts.$target.gz 1 | gzip > c2p.$target.$i.gz & done
#wait
#cat c2p.$target.{0..7}.gz > c2p.$target.gz
## $target.prjs.gz
#python grabpkgs.py Rprj2pkgs.1000.full $target | gzip >$target.prjs.gz
#zcat c2p.$target.gz |  perl ~audris/bin/grepField.perl $target.prjs.gz 2 | sort -u > cmt2prj.$target
#
#cat cmt2prj.$target |  perl -I ~audris/lib64/perl5 showCmt_tune.perl 1>$pre/pkgCmtTime.output.$target 2>$pre/pkgCmtTime.output.$target.err
#cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,7 | sort -t\; -n -k2,2 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su
### 2. 2 passes, 1st cmt clustering, 2nd sort by atime and each cluster only appears once.
##revise script cmt2passes.filter.py by adding in $pre on the path
#cat $pre/pkgCmtTime.output.$target | cut -d\; -f1,2,7 | sort -t\; -n -k3,3 | uniq | grep -v ';$' >$pre/pkgCmtTime.output.$target.su.4filter2
#cat $pre/pkgCmtTime.output.$target.su | cut -d\; -f1 | sort -u >$pre/pkgs.$target
#
#cat $pre/pkgs.$target | perl /da3_data/lookup/Prj2CmtShow.perl /data/basemaps/Prj2CmtH 1 8 1>$pre/pkg2cmts.output.$target 2>$pre/pkg2cmts.$target.err

cat $pre/pkgCmtTime.output.$target.su | python filterout_firsttime_pkg2atime.py >$pre/pkg2atime.thatpoint.$target 2>$pre/pkg2atime.thatpoint.$target.err
cat $pre/pkg2cmts.output.$target | python cmt2pkg2atime.py 2>$pre/cmt2pkg2atime.$target.err | perl -I ~audris/lib64/perl5 showCmt_tune2.perl 1>$pre/pkgAllCmtTime.output.$target 2>$pre/pkgAllCmtTime.output.$target.err

cat $pre/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su
#looks like in this file, sort is not needed, only uniq is needed. However, from the way it generates, it's unique naturally!
#cat $pre/pkgAllCmtTime.output.$target | cut -d\; -f1,2,5,7 | lsort 100G -t\; -n -k4,4 | uniq | grep -v ';$' > $pre/pkgAllCmtTime.output.$target.su
python numofCMTsAusuptothatPoint.py $pre/pkg2atime.thatpoint.$target $pre/pkgAllCmtTime.output.$target.su >$pre/numofCMTsAusuptothatPoint.$target 2>$pre/numofCMTsAusuptothatPoint.$target.err

cat $pre/pkg2atime.thatpoint.$target | sort -t\; -n -k2,2 >$pre/pkg2atime.thatpoint.$target.s
python numofPrjsAcuRec.py $pre/pkg2atime.thatpoint.$target.s 1>$pre/numofPrjsAcuRec.$target 2>$pre/numofPrjsAcuRec.$target.err
#now applying excluding forks
python cmt2passes.filter.intermedia.py $pre/pkgCmtTime.output.$target.su.4filter2 1>$pre/pkg2atime.filter2.thatpoint.$target 2>$pre/pkg2atime.filter2.thatpoint.$target.err
python allforks.filter.py $pre/pkgCmtTime.output.$target.su.4filter2 /data/basemaps/gz/c2pFullI.forks 1>$pre/pkg2atime.filter3.thatpoint.$target.dirty 2>$pre/pkg2atime.filter3.thatpoint.$target.dirty.err



python numofPrjsAcuRec.py $pre/pkg2atime.filter2.thatpoint.$target 1>$pre/numofPrjsAcuRec.filter2.$target 2>$pre/numofPrjsAcuRec.filter2.$target.err
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/numofCMTsAusuptothatPoint.$target 1 >$pre/numofCMTsAusuptothatPoint.$target.filter2





