target=$1
#target2=$2
pre=$2
prj=$3
#prj2=$5
echo $prj | perl p2c2a.perl /data/basemaps/Prj2CmtH 8 >$pre/authors.$target

cat $pre/authors.$target | cut -d\; -f2- | sed 's/;/\n/g' | sort -u >$pre/authors.$target.list
total_lines1=$(wc -l < $pre/authors.$target.list)
((lines_per_file1 = ($total_lines1 + 10 - 1) / 10))
split -l $lines_per_file1 -d -a 1 $pre/authors.$target.list $pre/authors.$target.list.
for i in {0..9}; do cat $pre/authors.$target.list.$i | perl a2c2p.perl /data/basemaps/Auth2CmtH /data/basemaps/Cmt2PrjH 8 >$pre/a2p.$target.$i & done
wait
cat $pre/a2p.$target.{0..9} >$pre/a2p.$target

#cat $pre/authors.$target | cut -d\; -f2- | sed 's/;/\n/g' | sort -u | perl a2c2p.perl /data/basemaps/Auth2CmtH /data/basemaps/Cmt2PrjH 8 > $pre/a2p.$target

# fork needs to be addressed since forks are not necessarily to be another project one touched.
cat $pre/a2p.$target | python a2p.filter.py $prj >$pre/a2p.$target.filter

#p2c2a
#grep -v -E  'tidyverse_tidyr|tidyverse_readr|tidyverse_tibble'
cat $pre/a2p.$target | cut -d\; -f2- | sed 's/;/\n/g' | sort -u | grep -v $prj > $pre/prjs.authors.$target

total_lines=$(wc -l < $pre/prjs.authors.$target)
((lines_per_file = ($total_lines + 10 - 1) / 10))
split -l $lines_per_file -d -a 1 $pre/prjs.authors.$target $pre/prjs.authors.$target.
for i in {0..9}; do cat $pre/prjs.authors.$target.$i | perl p2c2a.perl /data/basemaps/Prj2CmtH 8 >$pre/p2a.$target.$i & done
wait
cat $pre/p2a.$target.{0..9} > $pre/p2a.$target
# attention, a2p.*.filter contains empty line
python a2as.py $pre/a2p.$target.filter $pre/p2a.$target >$pre/a2as.$target

