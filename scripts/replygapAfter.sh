target=$1
target2=$2
pre=$3

cat ./$pre/firsttimereply.$target | python tune_firsttimereply_tobeready.py >$pre/firsttimereply.ready.$target
cat ./$pre/firsttimereply.$target2 | python tune_firsttimereply_tobeready.py >$pre/firsttimereply.ready.$target2
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/firsttimereply.ready.$target 1 >$pre/firsttimereply.ready.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 $pre/firsttimereply.ready.$target 1 >$pre/firsttimereply.ready.$target.filter3
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 $pre/firsttimereply.ready.$target2 1 >$pre/firsttimereply.ready.$target2.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target2 1 $pre/firsttimereply.ready.$target2 1 >$pre/firsttimereply.ready.$target2.filter3
