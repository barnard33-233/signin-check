#!/bin/bash

#config:
repo_addr="https://se.jisuanke.com/whu-summer-course-2022/404"
class_id="404"
id_file="./404.csv"
pass_file="../pass.csv"

if [! -f $pass_file]; then
    echo "缺少密码文件"
fi

# pull or clone from remote repo:
if [ ! -d $class_id ]; then
    git clone $repo_addr &>/dev/null
    cd ./$class_id
else
    cd ./$class_id
    git pull --all &>/dev/null
fi


#judge:
if [$1 == "all"]; then
    if [! -f $id_file]; then
        echo "缺少学号文件"
    fi
    for line in `cat $id_file`
    do
        check $line
    done
elif [$1 =~ [0-9] -a $2 =~ [0-9a-zA-Z]]; then
    check $1
else
    echo "usage: ./check.sh [student_id student_name | all]"



function check() # $1:学号
{
    stu_id="$1"
    branch_name=`git branch -a | grep $stu_id`

    if [branch_name = ""]; then
        echo "$stu_id: 缺少分支"
        return
    fi
    git checkout -f $branch_name &> /dev/null

    OLDIFS=$IFS
    IFS=","
    while read $mydate $pass
        if [! -f $mydate]; then
            echo "$stu_id: $mydate 签到文件缺失"
            return
        fi
        plaintext=$stu_id$pass$class_id
        md5val=`echo $plaintext | md5sum | cut -d ' ' -f1`
        md5val=`echo $plaintext | tr -d "\n" | md5sum | cut -d ' ' -f1`
        md5read=`cat $mydate | tr [A-Z] [a-z]`
        if [$md5read == $md5val -o $md5read == $md5val1]; then
            echo "$stu_id: $mydate md5验证失败"
        fi
    done < $pass_file
    IFS=OLDIFS
}