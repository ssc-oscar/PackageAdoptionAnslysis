cluster=$1
clustersMap=$2
cd fork_stat


echo $cluster > target.$cluster
zcat $clustersMap > clustersMap.nongz
python ../grepSubstitite.py target.$cluster 1 clustersMap.nongz 2 | cut -d\; -f1 >cluster.$cluster
cat cluster.$cluster | perl p2c.perl /data/basemaps/Prj2CmtH 8 > p2c.$cluster

#unque within cluster
cat p2c.$cluster | cut -d\; -f3- | sed 's/;/\n/g' | sort | uniq -u > $cluster.uniqueCmts
python grepSubCal.py $cluster.uniqueCmts 1 p2c.$cluster 3 >p2c.$cluster.uniq.ratio

#unque within all projects
cat $cluster.uniqueCmts | perl c2p.perl /data/basemaps/Cmt2PrjH 8 >c2p.uniq.$cluster
python ../grepSubstitite.py clustersMap.nongz 1 c2p.uniq.$cluster 2 | cut -d\; -f1 >$cluster.globalunique.Cmts
python grepSubCal.py $cluster.globalunique.Cmts 1 p2c.$cluster 3 >p2c.$cluster.globaluniq.ratio
