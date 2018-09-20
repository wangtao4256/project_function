#!/bin/bash
partition_list=(`df -h | awk 'NF>3&&NR>1{sub(/%/,"",$(NF-1));print $NF,$(NF-1)}'`)
#控制阈值，达到阈值报警发邮件
critical=80
notification_email()
{
    emailuser='wangtao_4256@163.com'
    emailpasswd=''
    #smtp信息
    emailsmtp=''
    sendto=''
    title='dxtyf-12 Disk Space Alarm'
    #支持发送至多用户
    /opt/sendEmail-v1.56/sendEmail -f $emailuser -t $sendto -s $emailsmtp -u $title -xu $emailuser -xp $emailpasswd
}
crit_info=""
for (( i=0;i<${#partition_list[@]};i+=2 ))
do
    if [ "${partition_list[((i+1))]}" -lt "$critical" ];then
        echo "OK! ${partition_list[i]} used ${partition_list[((i+1))]}%"
    else
            if [ "${partition_list[((i+1))]}" -gt "$critical" ];then
                crit_info=$crit_info"Warning!!!!!!\n${partition_list[i]} used ${partition_list[((i+1))]}%\n please clear hardware thank you\n"
            fi
    fi
done
if [ "$crit_info" != "" ];then
    echo -e $crit_info | notification_email
fi
