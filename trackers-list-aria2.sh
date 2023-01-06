#!/bin/bash

# aria2 设置文件路径
CONF=${HOME}/.aria2/aria2.conf


#设置选择的 trackerlist （可选 all_aria2.txt, best_aria2.txt, http_aria2.txt）
trackerfile=all_aria2.txt
downloadfile=https://trackerslist.com/${trackerfile}

# 推荐 大佬整合的下各类资源 需要自己写正则匹配
# 设置的bt-trackers 格式为 1tracker,2tracker,3tracker
# 大多数网站提供的都是 1tracker \n \n 2tracker \n \n 3tracker \n \n整齐排列
# 故需要将换行符替换为逗号才行，总之需要将格式弄成一行

## https://github.com/ngosang/trackerslist
#trackers1=trackers_best.txt
# trackers1=tracker_all.txt
# trackers1=tracker_udp.txt
# trackers1=tracker_http.txt
# trackers1=tracker_https.txt
# downloadfile=https://raw.githubusercontent.com/ngosang/trackerslist/master/${trackers1}

## https://github.com/XIU2/TrackersListCollection
#trackers2=best.txt
# trackers2=all.txt
# trackers2=http.txt
# downloadfile=https://jsd.cdn.zzko.cn/gh/XIU2/TrackersListCollection/${trackers2}


# 主要下动漫用的
# https://github.com/DeSireFire/animeTrackerList
#tracker3=AT_best.txt
# tracker3=ATaria2_all.txt
# tracker3=ATaria2_all_udp.txt
# tracker3=ATaria2_all_http.txt
# tracker3=ATaria2_all_https.txt
# tracker3=ATaria2_all_ws.txt
# tracker3=ATaria2_best_ip.txt
# tracker3=ATaria2_all_ip.txt
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
