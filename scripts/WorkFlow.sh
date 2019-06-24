#PBS -N getLANG.MAP
#PBS -A ACF-UTK0011
#PBS -l feature=monster
#PBS -l partition=monster
#PBS -l nodes=1,walltime=23:50:00
#PBS -j oe
#PBS -S /bin/bash
LD_LIBRARY_PATH=$HOME/lib:$HOME/lib64:$LD_LIBRARY_PATH
c=/lustre/haven/user/audris/basemaps
cd $c

#https://github.com/luislobo/common-js-file-extensions/blob/master/index.js
#'js|iced|liticed|iced.md|coffee|litcoffee|coffee.md|ts|cs|ls|es6|es|jsx|sjs|co|eg|json|json.ls|json5'
#R extensions: r|R|S|s
#py extensions: py|py3|pyx|pyo|pyw|pyc
LA=LANG
grepStr='\.(py|py3|pyx|pyo|pyw|pyc);'
if test $LA = 'JS'; then
grepStr='\.(js|iced|liticed|iced.md|coffee|litcoffee|coffee.md|ts|cs|ls|es6|es|jsx|sjs|co|eg|json|json.ls|json5);'
fi
if test $LA = 'R'; then
grepStr='(\.[Rr]|\.Rprofile|\.RData|\.Rhistory|\.Rproj|^NAMESPACE|^DESCRIPTION|/NAMESPACE|/DESCRIPTION);'
fi

if test 'a' = 'a'; then
if test 'a' = 'b'; then
grepStr=$(echo $grepStr|sed 's/;$/$/;s/\^/;/g')
for j in {0..31}
do zcat ../c2fb/c2fFullJ$j.s | grep -E "$grepStr" | gzip > c2fJ$LA.$j.gz &
done
wait
for j in {0..31}
do zcat ../c2fb/b2fFullJ$j.s | grep -E "$grepStr" | gzip > b2fJ$LA.$j.gz &
done
wait

for j in {0..31}
do zcat c2pFullJ$j.s | join -t\; - <(zcat c2fJ$LA.$j.gz|cut -d\; -f1|uniq) | gzip > c2pJ$LA.$j.gz &
done
wait
for j in {0..31}
do zcat ../c2fb/c2bFullJ$j.s | join -t\; - <(zcat c2fJ$LA.$j.gz|cut -d\; -f1|uniq) | gzip > c2bJ$LA.$j.gz &
done
wait
for j in {0..31}
do zcat ../c2fb/b2cFullJ$j.s | join -t\; - <(zcat b2fJ$LA.$j.gz|cut -d\; -f1|uniq) | gzip > b2cJ$LA.$j.gz &
done
wait
zcat c2pJ$LA.*.gz | cut -d\; -f2 | lsort 10G -u | gzip > pJ$LA.gz
zcat c2pFullJ.forks | lsort 10G -t\; -k1b,1 | join -t\; -k1b,2 - <(zcat pJ$LA.gz) | gzip > pJ$LA.forks
for j in {0..31}
do zcat b2cJ$LA.$j.gz
done | cut -d\; -f1 | uniq |  $HOME/lookup/splitSec.perl bJ$LA. 128
#for j in {0..31}; do zcat c2ta.$j.gz | lsort 10G -t\; -k1b,1 | lsort 25G -t\; -k1b,1 --merge - <(zcat c2ta.$(($j+32)).gz|lsort 10G -t\; -k1b,1) <(zcat c2ta.$(($j+64)).gz|lsort 10G -t\; -k1b,1) <(zcat c2ta.$(($j+96)).gz|lsort 10G -t\; -k1b,1) | gzip > c2ta.$j.s; done &
#
for j in {0..31}
do zcat c2ta.$j.s | lsort 1G -t\; -k1b,1 | join -t\; - <(zcat c2fJ$LA.$j.gz|cut -d\; -f1|uniq) | gzip > c2taJ$LA.$j.gz &
done
wait
# map forks
for j in {0..31}
do zcat c2pJ$LA.$j.gz |  perl mp.perl 1 pJ$LA.forks | uniq | lsort 500M -u | gzip > c2PJ$LA.$j.gz &
done
wait

for j in {0..31}
do zcat c2PJ$LA.$j.gz | join -t\; - <(zcat c2taJ$LA.$j.gz) | gzip > c2PtaJ$LA.$j.gz &
done
wait

for j in {0..31}
do zcat c2bJ$LA.$j.gz | join -t\; - <(zcat c2PtaJ$LA.$j.gz) | gzip > c2bPtaJ$LA.$j.gz &
done
wait
fi

for j in {0..31}
do zcat c2bPtaJ$LA.$j.gz | awk -F\; '{print $2";"$1";"$3";"$4";"$5}'
done | lsort 700G -t\; -k1b,1 | gzip > b2cPtaJ$LA.gz
zcat b2cPtaJ$LA.gz| $HOME/lookup/splitSec.perl b2cPtaJ$LA. 32

if test 'a' = 'b'; then

for j in {0..31}
do zcat bJ${LA}pkgs.$j.gz | lsort 100M -t\; -k1b,1 | \
  lsort 1G -t\; -k1b,1 --merge - <(zcat bJ${LA}pkgs.$(($j+32)).gz|lsort 100M -t\; -k1b,1) \
    <(zcat bJ${LA}pkgs.$(($j+64)).gz|lsort 100M -t\; -k1b,1) \
    <(zcat bJ${LA}pkgs.$(($j+96)).gz|lsort 100M -t\; -k1b,1) | \
    perl -ane 'print if m/^[0-f]{40};/' | uniq | \
    gzip > bJ${LA}pkgs.$j.s &
done
wait

for j in {0..31}
do zcat b2cPtaJ$LA.$j.gz | join -t\; - <(zcat bJ${LA}pkgs.$j.s) | gzip > b2cPtaPkgJ$LA.$j.gz &
done
wait
zcat b2cPtaPkgJR.*.gz| grep data.table | cut -d\; -f3-5 | lsort 1G -t\; -n -k1b,2 | awk -F\; 'BEGIN {p=""} {if ($1 != p) print; p=$1; }' | gzip > DT.srt

fi

