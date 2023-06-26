#!/bin/bash

# aria2 设置文件路径
CONF=${HOME}/.aria2/aria2.conf

# 推荐 大佬整合的下各类资源 需要自己写正则匹配
# 由于aria2命令行设置的bt-trackers 格式为 1tracker,2tracker,3tracker
# 但大多数网站提供的都是 1tracker \n \n 2tracker \n \n 3tracker \n \n整齐换行排列
# 故需要将换行符替换为逗号才行，总之需要将格式弄成一行


#设置选择的 trackerlist （可选 all_aria2.txt, best_aria2.txt, http_aria2.txt）
# 同下XIU2
trackerfile=all_aria2.txt
downloadfile=https://trackerslist.com/${trackerfile}

## https://github.com/XIU2/TrackersListCollection
# trackers2=best.txt
# trackers2=all.txt
# downloadfile=https://cf.trackerslist.com/${trackers2}

## https://github.com/ngosang/trackerslist
# trackers1=trackers_best.txt
# trackers1=trackers_all.txt
# downloadfile=https://raw.githubusercontent.com/ngosang/trackerslist/master/${trackers1}

# 这个主要下冻鳗用的
# https://github.com/DeSireFire/animeTrackerList
# tracker3=ATaria2_best.txt
# tracker3=ATaria2_all.txt
# downloadfile=https://cdn.jsdelivr.net/gh/DeSireFire/animeTrackerList/${tracker3}

echo -e "链接:${downloadfile}"
list=$(curl -fsSL ${downloadfile})
if ! grep -q "bt-tracker" "${CONF}" ; then
    echo -e "\033[34m==> 添加 bt-tracker 服务器信息......\033[0m"
    echo -e "\nbt-tracker=${list}" >> "${CONF}"
else
    echo -e "\033[34m==> 更新 bt-tracker 服务器信息.....\033[0m"
    sed -i '' '/^$/d' "${list}"
    sed -i '' -n -e 'H;${x;s/\n/,/g;p;}' "${list}"
    sed -i '' -e '1s/^.//' "${list}"
    # 将在{CONF}中匹配到以bt-tracker开头的该行所有内容替换为bt-tracker={list内容} 
    sed -i '' "s@bt-tracker.*@bt-tracker=${list}@g" "${CONF}"
    echo -e "更新完毕"
fi

## 重启 aria2 服务
echo -e "\033[34m==> 正在停止 aria2 服务......\033[0m"
launchctl stop aria2
echo -e "\033[34m==> 正在启动 aria2 服务......\033[0m"
launchctl start aria2
