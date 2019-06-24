target=$1
target2=$2
pre=$3


echo 'abcd;1520535165' | python3 filterouttiydplusdatatable_threeQuestions.py stackoverflow-17-12 Posts Title,Body $target
echo 'abcd;1520535165' | python3 filterouttiydplusdatatable_threeQuestions.py stackoverflow-17-12 Posts Title,Body $target2
cat $pre/pkg2atime.thatpoint.$target.s | cut -d ' ' -f1 | python3 stackoverflow/grabdatatable.title.mongo.new.py stackoverflow-17-12 Posts_title_body_question_20$target Posts_title_body_question_20$target2  >stackoverflow/stackoverflow_prj2both.$target  2>stackoverflow/stackoverflow_prj2both.$target.err
cat $pre/pkg2atime.thatpoint.$target2.s | cut -d ' ' -f1 | python3 stackoverflow/grabdatatable.title.mongo.new.py stackoverflow-17-12 Posts_title_body_question_20$target Posts_title_body_question_20$target2  >stackoverflow/stackoverflow_prj2both.$target2 2>stackoverflow/stackoverflow_prj2both.$target2.err

python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target 1 stackoverflow/stackoverflow_prj2both.$target 1 >./$pre/stackoverflow_prj2both.$target.filter2 2>./$pre/stackoverflow_prj2both.$target.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target 1 stackoverflow/stackoverflow_prj2both.$target 1 >./$pre/stackoverflow_prj2both.$target.filter3 2>./$pre/stackoverflow_prj2both.$target.filter3
python grepSubstitite.py $pre/pkg2atime.filter2.thatpoint.$target2 1 stackoverflow/stackoverflow_prj2both.$target2 1 >./$pre/stackoverflow_prj2both.$target2.filter2 2>./$pre/stackoverflow_prj2both.$target2.filter2
python grepSubstitite.py $pre/pkg2atime.filter3.thatpoint.$target2 1 stackoverflow/stackoverflow_prj2both.$target2 1 >./$pre/stackoverflow_prj2both.$target2.filter3 2>./$pre/stackoverflow_prj2both.$target2.filter3
