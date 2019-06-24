target=$1
target2=$2
pre=$3


#filter first adoption

python firstchoice.py $pre/pkg2atime.filter3.thatpoint.$target.dirty  $pre/pkg2atime.filter3.thatpoint.$target2.dirty $pre/pkg2atime.filter3.thatpoint.$target  $pre/pkg2atime.filter3.thatpoint.$target2 2>$pre/firstchoice.err


python numofPrjsAcuRec.py $pre/pkg2atime.filter3.thatpoint.$target 1>$pre/numofPrjsAcuRec.filter3.$target 2>$pre/numofPrjsAcuRec.filter3.$target.err
python numofPrjsAcuRec.py $pre/pkg2atime.filter3.thatpoint.$target2 1>$pre/numofPrjsAcuRec.filter3.$target2 2>$pre/numofPrjsAcuRec.filter3.$target2.err
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 $pre/numofCMTsAusuptothatPoint.$target 1 >$pre/numofCMTsAusuptothatPoint.$target.filter3
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target2 1 $pre/numofCMTsAusuptothatPoint.$target2 1 >$pre/numofCMTsAusuptothatPoint.$target2.filter3



python numofPrjsAcuRecCross.py  $pre/pkg2atime.thatpoint.$target.s   $pre/pkg2atime.thatpoint.$target2.s $pre/numofPrjsAcuRecCross 2> $pre/numofPrjsAcuRecCross.err
python numofPrjsAcuRecCross.py $pre/pkg2atime.filter2.thatpoint.$target $pre/pkg2atime.filter2.thatpoint.$target2 $pre/numofPrjsAcuRecCross.filter2 2>>numofPrjsAcuRecCross.err
python numofPrjsAcuRecCross.py $pre/pkg2atime.filter3.thatpoint.$target $pre/pkg2atime.filter3.thatpoint.$target2 $pre/numofPrjsAcuRecCross.filter3 2>>numofPrjsAcuRecCross.err
