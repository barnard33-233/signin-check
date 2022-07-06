# signin-check
实验一下小学期助教签到脚本

master下的newcheck.sh为新的脚本

## 说明

./newcheck all #检测所有人的签到情况

./newcheck [学号] #查询特定学号的签到情况

报错信息：
1. `[student_id]: 缺少分支`
2. `[student_id]: 分支过多，需手动查看` 当前repo下检测到的该学号对应的分支大于1个，分不清哪个是真正用于打卡的
3. `[student_id]: [时间] 签到文件缺失` 
4. `[student_id]: md5不匹配` 说明文件中的字符串和脚本算的不一样，说明学号，密码，房间号或者后面算md5的过程有错。

文件：
1. `id_file`:学号文件，一行是一个学号（如repo中的`404.csv`，可以直接excel保存成csv用）
2. `pass_file`:密码文件，记录所有已有的密码，每行是“日期,密码的格式”（如repo中的`pass.csv`）

这些文件需要和脚本放在同一个文件夹中，记得改脚本中的常量名称

需要的文件结构：
```
├── 404            repo
├── 404.csv        学号文件
├── pass.csv       密码文件
└── 其他东西
```



还有的问题：当一个学号对应的branch超过一个就没办法正常工作了
