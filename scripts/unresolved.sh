target=$1
pre=$2
cat ./$pre/avgresptime.$target | cut -d\; -f1,4,5 >./$pre/unresolvedNum.$target
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 ./$pre/unresolvedNum.$target 1 >./$pre/unresolvedNum.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 ./$pre/unresolvedNum.$target 1 >./$pre/unresolvedNum.$target.filter3
