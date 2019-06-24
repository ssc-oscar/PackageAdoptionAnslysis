target=$1
target2=$2
pre=$3

python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target >$pre/closeness2both.$target
python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target.filter3 >$pre/closeness2both.$target.filter3
python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target2 >$pre/closeness2both.$target2
python closeness.py $pre/dependenciesweight $pre/pcbPkg.$target2.filter3 >$pre/closeness2both.$target2.filter3

