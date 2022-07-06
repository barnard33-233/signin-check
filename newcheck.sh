#!/bin/bash

#config:
repo_addr="https://se.jisuanke.com/whu-summer-course-2022/404"
# repo_addr="git@github.com:barnard33-233/signin-check.git" # for test
repo_name="404"
class_id="404"
id_file="../404.csv"
pass_file="../pass.csv"


function check(){
    stu_id="$1"
    stu_name="$2"
    if [ "$stu_name" != "" ]; then
        branch_name=$stu_id$stu_name
        git checkout $branch_name &> /dev/null
        if [ $? != 0 ]; then
            echo "$stu_id: 缺少分支"
            return
        fi
    else
        branch_name=`git branch | grep $stu_id`
        if [ "$branch_name" == "" ]; then
            echo "$stu_id: 缺少分支"
            return
        fi
        git checkout $branch_name &> /dev/null
        if [ $? != 0 ]; then
            echo "$stu_id: 分支过多，需手动检查"
            return
        fi
    fi
    # echo "----$stu_id----" #debug info


    for line in `cat $pass_file`
    do
        mydate=`echo $line | cut -d ',' -f1`
        pass=`echo $line | cut -d ',' -f2`
        if [ ! -f "$mydate" ]; then
            echo "$stu_id: $mydate 签到文件缺失"
            continue
        fi
        plaintext=$stu_id$pass$class_id
        md5val=`echo $plaintext | md5sum | cut -d ' ' -f1`
        md5val1=`echo $plaintext | tr -d "\n" | md5sum | cut -d ' ' -f1`
        md5read=`cat $mydate | tr [A-Z] [a-z]`
        if [ "$md5read" != "$md5val" -a "$md5read" != "$md5val1" ]; then
            echo "$stu_id: $mydate md5验证失败"
        else
            echo "$stu_id: $mydate 成功"
        fi
    done < $pass_file
}

# pull or clone from remote repo:
if [ ! -d $repo_name ]; then
    git clone $repo_addr &>/dev/null
    cd ./$repo_name
    if [ "$1" == "all" ]; then
        git branch -r | grep -v '\->' | 
        while read remote
        do
            git branch --track "${remote#origin/}" "$remote"
        done
        git fetch --all &>/dev/null
        git pull --all &>/dev/null
    fi
else
    cd ./$repo_name
    if [ "$1" == "all" ]; then
        git branch -r | grep -v '\->' | 
        while read remote
        do
            git branch --track "${remote#origin/}" "$remote"
        done
        git fetch --all &>/dev/null
    fi
    git pull --all &>/dev/null
fi

if [ ! -f $pass_file ]; then
    echo "缺少密码文件"
    exit
fi


#judge:
if [ "$1" == "all" ]; then
    if [ ! -f $id_file ]; then
        echo "缺少学号文件"
        exit
    fi
    for line in `cat $id_file`
    do
        check $line
    done
elif [[ "$1" =~ [0-9] ]]; then
    if [ "$2" != "" ]; then
        check $1 $2
    else
        check $1
    fi
else
    echo "usage: ./check.sh [student_id student_name | all]"
fi