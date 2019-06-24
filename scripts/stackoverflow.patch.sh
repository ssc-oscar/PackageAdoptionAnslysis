target=$1
target2=$2
pre=$3

#echo 'abcd;1520535165' | python filterouttiydplusdatatable.py stackoverflow-17-12 Posts Title $target
#echo 'abcd;1520535165' | python filterouttiydplusdatatable.py stackoverflow-17-12 Posts Title $target2
cat $pre/pkg2atime.thatpoint.$target.s | cut -d ' ' -f1 | python stackoverflow/grabdatatable.title.mongo.new.py stackoverflow-17-12 Posts_title_$target Posts_title_$target2  >stackoverflow/stackoverflow_prj2both.$target.full
cat $pre/pkg2atime.thatpoint.$target2.s | cut -d ' ' -f1 | python stackoverflow/grabdatatable.title.mongo.new.py stackoverflow-17-12 Posts_title_$target Posts_title_$target2  >stackoverflow/stackoverflow_prj2both.$target2.full

python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 stackoverflow/stackoverflow_prj2both.$target.full 1 >./$pre/stackoverflow_prj2both.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 stackoverflow/stackoverflow_prj2both.$target2.full 1 >./$pre/stackoverflow_prj2both.$target2.filter2
