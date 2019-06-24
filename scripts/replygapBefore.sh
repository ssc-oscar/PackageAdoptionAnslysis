target=$1
target2=$2
pre=$3
repo=$4
repo2=$5

python github_retrieve_metadata.py inthesunset 333369xm ./$pre/ $repo $target 2>./$pre/retrieve.$target.err
python github_retrieve_metadata.py inthesunset 333369xm ./$pre/ $repo2 $target2 2>./$pre/retrieve.$target2.err
python3 responsetime.py $target  1>./$pre/$target.resp.time 2>./$pre/$target.resp.time.err
python3 responsetime.py $target2  1>./$pre/$target2.resp.time 2>./$pre/$target2.resp.time.err
cat ./$pre/$target.resp.time | sort -t\; -n -k1,1 >./$pre/$target.resp.time.s
cat ./$pre/$target2.resp.time | sort -t\; -n -k1,1 >./$pre/$target2.resp.time.s
python avgresptime.py ./$pre/pkg2atime.thatpoint.$target.s ./$pre/$target.resp.time.s ./$pre/$target2.resp.time.s 1>./$pre/avgresptime.$target 2>./$pre/avgresptime.$target.err
python avgresptime.py ./$pre/pkg2atime.thatpoint.$target2.s ./$pre/$target.resp.time.s ./$pre/$target2.resp.time.s 1>./$pre/avgresptime.$target2 2>./$pre/avgresptime.$target2.err
python preparedata_survivalmodel_right.py ./$pre/$target.resp.time.s ./$pre/$target2.resp.time.s 1>./$pre/survival_data 2>./$pre/survival_data.err
python preparedata_survivalmodel.py ./$pre/pkg2atime.thatpoint.$target.s 1>./$pre/being.$target
python preparedata_survivalmodel.py ./$pre/pkg2atime.thatpoint.$target2.s 1>./$pre/being.$target2


