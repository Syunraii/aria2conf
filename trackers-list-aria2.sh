#!/bin/bash
#trackers-list-aria2.sh

# aria2 设置文件路径 改为自己的路径 
CONF=${HOME}/.aria2/aria2.conf

# 推荐 大佬整合的下各类资源
## https://github.com/ngosang/trackerslist
trackers1 = trackers_best.txt
# trackers1 = tracker_all.txt
# trackers1 = tracker_udp.txt
# trackers1 = tracker_http.txt
# trackers1 = tracker_https.txt
#downloadfile=https://raw.githubusercontent.com/ngosang/trackerslist/master/${}

## https://github.com/XIU2/TrackersListCollection
trackers2 = best.txt
# trackers2 = all.txt
# trackers2 = http.txt
# downloadfile=https://jsd.cdn.zzko.cn/gh/XIU2/TrackersListCollection/${trackers2}

# 主要下载动漫
# https://github.com/DeSireFire/animeTrackerList
tracker3 = AT_best.txt
# tracker3 = AT_all.txt
# tracker3 = AT_all_ip.txt
# tracker3 = AT_all_udp.txt
# tracker3 = AT_all_http.txt
# tracker3 = AT_all_https.txt
downloadfile=https://github.com/DeSireFire/animeTrackerList/blob/master/${tracker3}


list=$(curl -fsSL ${downloadfile})
if ! grep -q "bt-tracker" "${CONF}" ; then
    echo -e "\033[34m==> 添加 bt-tracker 服务器信息......\033[0m"
    echo -e "\nbt-tracker=${list}" >> "${CONF}"
else
    echo -e "\033[34m==> 更新 bt-tracker 服务器信息.....\033[0m"
    sed -i '' "s@bt-tracker.*@bt-tracker=${list}@g" "${CONF}"
fi

## 重启 aria2 服务
echo -e "\033[34m==> 正在停止 aria2 服务......\033[0m"
launchctl stop aria2
echo -e "\033[34m==> 正在启动 aria2 服务......\033[0m"
launchctl start aria2
