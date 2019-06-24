target1=$1
clusters=$2
list=$3
pre=$4

echo $target1 > $pre/$target1.tmp
zcat $clusters > $pre/clusters.nongz
python grepSubstitite.py $pre/$target1.tmp 1 $pre/clusters.nongz 1 | sort -u | cut -d\; -f2 > $pre/$target1.canonical
python grepSubstitite.py  $pre/$list 1 $pre/clusters.nongz 1 | cut -d\; -f2 | sort -u >$pre/$target1.prjs.canonical
python grepSubstitite.py $pre/$target1.canonical 1 $pre/$target1.prjs.canonical 1 0 > $pre/$target1.prjs.canonical.exclude

#rm $pre/$target1.tmp
#rm $pre/clusters.nongz

