target=$1
target2=$2
pre=$3

python closeness.py dplyrVSHmisc/dependenciesweight $pre/pcbPkg.$target >$pre/closeness2both.$target
python closeness.py dplyrVSHmisc/dependenciesweight $pre/pcbPkg.$target2 >$pre/closeness2both.$target2

python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 dplyrVSHmisc/closeness2both.$target 1 >$pre/closeness2both.$target.old
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 dplyrVSHmisc/closeness2both.$target2 1 >$pre/closeness2both.$target2.old

cat $pre/closeness2both.$target $pre/closeness2both.$target.old >$pre/closeness2both.$target.full
cat $pre/closeness2both.$target2 $pre/closeness2both.$target2.old >$pre/closeness2both.$target2.full
