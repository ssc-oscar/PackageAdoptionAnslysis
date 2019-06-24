target=$1
pre=$2

cat $pre/pkg2cmts.output.$target | cut -d\; -f1,3- | perl -I ~audris/lib64/perl5  grabCfiles.perl /data/basemaps/c2fFullH 1 8   1>$pre/cpfs.$target 2>$pre/cpfs.$target.err
####
cat $pre/cpfs.$target | cut -d\; -f1,2 | sort -u | perl -I ~audris/lib64/perl5 showCmt_tune.perl 1>$pre/CpkgCmtTime.output.$target 2>$pre/CpkgCmtTime.output.$target.err
cat $pre/CpkgCmtTime.output.$target | cut -d\; -f1,7 | sort -t\; -n -k2,2 | uniq | grep -v ';$' >$pre/CpkgCmtTime.output.$target.su
cat $pre/CpkgCmtTime.output.$target.su | python filterout_firsttime_pkg2atime.py >$pre/Cpkg2firsttime.$target 2>$pre/Cpkg2firsttime.$target.err
# now compare, firsttime of Cpkg with pkg2atime.thatpoint to see if C file already exists before applying datatable/tidy package.
python containCfile.py $pre/Cpkg2firsttime.$target $pre/pkg2atime.thatpoint.$target >$pre/ContainCfiles.$target
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 $pre/ContainCfiles.$target 1 >$pre/ContainCfiles.filter2.$target
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 $pre/ContainCfiles.$target 1 >$pre/ContainCfiles.filter3.$target

