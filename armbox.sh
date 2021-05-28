#! /bin/bash
# By BlueSkyXN
#https://github.com/BlueSkyXN/SKY-BOX

#彩色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}

#下载 IPV.SH IPv4/IPv6 优先级调整一键脚本
function ipvsh(){
	wget -O "/root/ipv.sh" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/ipv.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/ipv.sh"
	blue "下载完成"
	blue "输入 bash /root/ipv.sh 来运行"
}

#下载 IPT.SH iptables 一键脚本
#https://github.com/arloor/iptablesUtils
function iptsh(){
	wget -O "/root/ipt.sh" "https://raw.githubusercontent.com/arloor/iptablesUtils/master/natcfg.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/ipt.sh"
	blue "下载完成"
	blue "输入 bash /root/ipt.sh 来运行"
}

#下载 SpeedTest for Linux 并安装为命令
function speedtest-linux(){
	wget -O "/usr/local/bin/speedtest" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/speedtestarm" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/usr/local/bin/speedtest"
	blue "下载完成"
	blue "输入 speedtest 来运行"
}

#获取本机 IP 地址
function getip(){
	echo  
	curl ip.p3terx.com
	echo
}


#安装最新 BBR 内核（仅支持 CentOS）
function bbrnew(){
	if [ -e "/etc/redhat-release" ];then
		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
		yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
		yum --enablerepo=elrepo-kernel -y install kernel-ml kernel-ml-devel
		grub2-set-default 0
		blue "BBR 内核安装结束，开始修复 grub"
		yum install -y grub
		grub-mkconfig -o /boot/grub/grub.conf
		yum install -y grub2
		grub2-mkconfig -o /boot/grub2/grub.cfg
		blue "修复 grub 完成，显示内核参数如下"
		echo " =================================================="
		yellow "当前正在使用的内核"
		uname -a
		echo " =================================================="
		yellow "系统已经安装的全部内核"
		rpm -qa | grep kernel
		echo " =================================================="
		yellow "可使用的内核列表"
		awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
		echo " =================================================="
		yellow "当前默认内核启动项"
		echo
		grub2-editenv list
		echo " =================================================="
		yellow "请自行重启后启动BBR加速"
		echo " =================================================="
	else 
		echo -e "${Font_Red}暂时不支持您的系统${Font_Suffix}";
	exit;
	fi	
}


#启用 BBR FQ 算法
function bbrfq(){
	remove_bbr_lotserver
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.d/99-sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.d/99-sysctl.conf
	sysctl --system
	echo -e "BBR+FQ修改成功，重启生效！"
}

#优化系统网络配置
function system-best(){
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf

	echo "net.ipv4.tcp_retries2 = 8
	net.ipv4.tcp_slow_start_after_idle = 0
	fs.file-max = 1000000
	fs.inotify.max_user_instances = 8192
	net.ipv4.tcp_syncookies = 1
	net.ipv4.tcp_fin_timeout = 30
	net.ipv4.tcp_tw_reuse = 1
	net.ipv4.ip_local_port_range = 1024 65000
	net.ipv4.tcp_max_syn_backlog = 16384
	net.ipv4.tcp_max_tw_buckets = 6000
	net.ipv4.route.gc_timeout = 100
	net.ipv4.tcp_syn_retries = 1
	net.ipv4.tcp_synack_retries = 1
	net.core.somaxconn = 32768
	net.core.netdev_max_backlog = 32768
	net.ipv4.tcp_timestamps = 0
	net.ipv4.tcp_max_orphans = 32768
	# forward ipv4
	#net.ipv4.ip_forward = 1">>/etc/sysctl.conf
	sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "需要重启VPS后，才能生效系统优化配置，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}

#MT.SH 流媒体解锁测试
#https://github.com/CoiaPrant/MediaUnlock_Test
function mtsh(){
        #安装JQ
	if [ -e "/etc/redhat-release" ];then
		yum install epel-release -y -q > /dev/null;
		yum install jq -y -q > /dev/null;
	elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
		apt-get update -y > /dev/null;
		apt-get install jq > /dev/null;
	else 
		echo -e "${Font_Red}请手动安装jq${Font_Suffix}";
	exit;
	fi

        jq -V > /dev/null 2>&1;
        if [ $? -ne 0 ];then
		echo -e "${Font_Red}请手动安装jq${Font_Suffix}";
	exit;
        fi

	wget -O "/root/mt.sh" "https://raw.githubusercontent.com/CoiaPrant/MediaUnlock_Test/main/check.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/mt.sh"
	blue "下载完成"
	blue "你也可以输入 bash /root/mt.sh 来手动运行"
	bash /root/mt.sh
}

#下载 Rclone & Fclone 并安装为命令
function clonesh(){
	wget -O "/usr/local/bin/rclone" "https://raw.githubusercontent.com/BlueSkyXN/RcloneX/master/rclonearm" --no-check-certificate -T 30 -t 5 -d
	wget -O "/usr/local/bin/fclone" "https://raw.githubusercontent.com/BlueSkyXN/RcloneX/master/fclonearm" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/usr/local/bin/rclone"
	chmod +x "/usr/local/bin/fclone"
}

#下载 ChangeSource Linux 换源脚本
function cssh(){
	wget -O "/root/changesource.sh" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/changesource.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/changesource.sh"
	chmod 777 "/root/changesource.sh"
	blue "下载完成"
	echo
	green "请自行输入下面命令切换对应源"
	green " =================================================="
	echo
	green " bash changesource.sh 切换推荐源 "
	green " bash changesource.sh cn 切换到中科大源 "
	green " bash changesource.sh aliyun 切换到阿里源 "
	green " bash changesource.sh 163 切换到网易源 "
	green " bash changesource.sh aws 切换到 AWS 源 "
	green " bash changesource.sh restore 还原默认源 "
}

#下载 Besttrace 路由追踪并安装为命令
function gettrace(){
	wget -O "/usr/local/bin/besttrace" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/besttracearm" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/usr/local/bin/besttrace"
	blue "下载完成"
	blue "输入 besttrace 加上相应参数来运行"
}

#Lemonbench 综合测试
#https://blog.ilemonrain.com/linux/LemonBench.html
function Lemonbench(){
	curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
}

#UNIXbench 综合测试
#https://github.com/teddysun/across
function UNIXbench(){
	wget -O "/root/unixbench.sh" "https://raw.githubusercontent.com/teddysun/across/master/unixbench.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/unixbench.sh"
	blue "下载完成"
	bash "/root/unixbench.sh"
}

#三网 Speedtest 测速
function 3speed(){
	bash <(curl -Lso- https://git.io/superspeed)
}

#Superbench 综合测试
#https://www.oldking.net/350.html
function superbench(){
	wget -O "/root/superbench.sh" "https://raw.githubusercontent.com/oooldking/script/master/superbench.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/superbench.sh"
	blue "下载完成"
	bash "/root/superbench.sh"
}

#Memorytest 内存压力测试
#https://github.com/FunctionClub/Memtester
function memorytest(){
	yum groupinstall "Development Tools" -y
	wget https://raw.githubusercontent.com/FunctionClub/Memtester/master/memtester.cpp --no-check-certificate -T 30 -t 5 -d
	blue "下载完成"
	gcc -l stdc++ memtester.cpp
	./a.out
}

#下载并安装 NEZHA.SH 哪吒面板/探针
#https://github.com/duanpingbo/nezha
function nezha(){
	wget -O "/root/nezha.sh" "https://raw.githubusercontent.com/BlueSkyXN/nezha/master/script/install.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/nezha.sh"
	blue "你也可以输入 bash /root/nezha.sh 来手动运行"
	blue "下载完成"
	bash "/root/nezha.sh"
}



#Aria2 最强安装与管理脚本
#https://github.com/P3TERX/aria2.sh
function aria(){
	wget -O "/root/aria2.sh" "https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/aria2.sh"
	blue "你也可以输入 bash /root/aria2.sh 来手动运行"
	blue "下载完成"
	bash "/root/aria2.sh"
}

#MTP&TLS 一键脚本
#https://github.com/sunpma/mtp
function mtp(){
	wget -O "/root/mtp.sh" "https://raw.githubusercontent.com/sunpma/mtp/master/mtproxy.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/mtp.sh"
	blue "你也可以输入 bash /root/mtp.sh 来手动运行"
	blue "下载完成"
	bash "/root/mtp.sh"
}

#V2UI 一键脚本
#https://github.com/sprov065/v2-ui
function v2ui(){
	bash <(curl -Ls https://blog.sprov.xyz/v2-ui.sh)
}

#宝塔面板 官方版·一键安装
function btnew(){
	wget -O "/root/install.sh" "http://download.bt.cn/install/install_panel.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/install.sh"
	blue "下载完成"
	bash "/root/install.sh"
}

#宝塔面板 官方版·一键更新
function btrenew(){
	curl http://download.bt.cn/install/update6.sh | bash
}

#宝塔面板 5.9开源免费版·一键安装
function btold(){
	wget -O "/root/install.sh" "http://download.bt.cn/install/install.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/install.sh"
	blue "下载完成"
	bash "/root/install.sh"
}

#宝塔面板 Hostcli 破解版·一键安装
function bthostcli(){
	wget -O "/root/install.sh" "http://download.hostcli.com/install/install_6.0.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/install.sh"
	blue "下载完成"
	bash "/root/install.sh"
}

#宝塔面板 Hostcli 破解版·一键转移
function bthostcli-new(){
	wget -O "/root/update7.sh" "http://download.hostcli.com/install/update7.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/update7.sh"
	blue "下载完成"
	bash "/root/update7.sh"
}

#莉塔面板·一键安装（安装后需要更新一下）
function lt(){
	curl -sSO https://download.fenhao.me/ltd/install/install_panel.sh | bash
}

#莉塔面板·一键更新（安装后需要更新一下）
function lt-new(){
	curl https://download.fenhao.me/ltd/install/update6.sh | bash
}

#莉塔面板·CentOS专用（安装后需要更新一下）
function ltc(){
	wget -O install.sh https://download.fenhao.me/ltd/install/install_6.0.sh && sh install.sh
}

#宝塔面板 自动磁盘挂载工具
function btdisk(){
	wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
}

#安装 GIT 新版（仅支持 CentOS）
function yumgitsh(){
	wget -O "/root/yum-git.sh" "https://raw.githubusercontent.com/BlueSkyXN/Yum-Git/main/yum-git.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/yum-git.sh"
	blue "下载完成"
	blue "你也可以输入 bash /root/yum-git.sh 来手动运行"
	bash "/root/yum-git.sh"
}

#BBR 一键管理脚本（卸载内核版本）
#https://github.com/ylx2016/Linux-NetSpeed
function tcpsh(){
	wget -O "/root/tcp.sh" "https://raw.githubusercontent.com/ylx2016/Linux-NetSpeed/master/tcp.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/tcp.sh"
	blue "下载完成"
	blue "你也可以输入 bash /root/tcp.sh 来手动运行"
	bash "/root/tcp.sh"
}

#SWAP 一键安装/卸载
function swapsh(){
	wget -O "/root/swap.sh" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/swap.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/swap.sh"
	blue "下载完成"
	blue "你也可以输入 bash /root/swap.sh 来手动运行"
	bash "/root/swap.sh"
}

#Route-trace 路由追踪测试
function rtsh(){
	wget -O "/root/rt.sh" "https://raw.githubusercontent.com/BlueSkyXN/Route-trace/main/rt.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/rt.sh"
	blue "下载完成"
	blue "你也可以输入 bash /root/rt.sh 来手动运行"
	bash "/root/rt.sh"
}

#Yabs.sh测试
#https://github.com/masonr/yet-another-bench-script
function yabssh(){
	wget -O "/root/yabs.sh" "https://raw.githubusercontent.com/masonr/yet-another-bench-script/master/yabs.sh" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/yabs.sh"
	blue "下载完成"
	bash "/root/yabs.sh"
}

#Disk Test 硬盘&系统综合测试
#https://github.com/Aniverse/A
function disktestsh(){
	wget -O "/root/disktest.sh" "https://raw.githubusercontent.com/Aniverse/A/i/a" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/root/disktest.sh"
	blue "下载完成"
	bash "/root/disktest.sh"
}

#TubeCheck Google/Youtube CDN分配节点测试
#https://github.com/sjlleo/TubeCheck
function tubecheck(){
	wget -O "/usr/local/bin/tubecheck" "https://github.com/sjlleo/TubeCheck/releases/download/1.0Beta/tubecheck_1.0beta_linux_amd64" --no-check-certificate -T 30 -t 5 -d
	chmod +x "/usr/local/bin/tubecheck"
	blue "下载完成"
	red "识别成无信息/NULL/未知等代表为默认的美国本土地区或者不可识别/无服务的中国大陆地区"
	tubecheck
}

#甲骨文ARM U20 DD Debian 10 
function armddd10(){
	red "默认密码blueskyxn"
	curl -fLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh
	red "默认密码blueskyxn"
	chmod a+rx debi.sh
	red "默认密码blueskyxn"
	./debi.sh --architecture arm64 --user root --password blueskyxn
	red "默认密码blueskyxn"
	shutdown -r now
}

#主菜单
function start_menu(){
    clear
    red " BlueSkyXN 综合工具箱 ARM Beta" 
    green " FROM: https://github.com/BlueSkyXN/SKY-BOX "
    green " HELP: https://www.blueskyxn.com/202104/4465.html "
    green " USE:  wget -O box.sh https://raw.githubusercontent.com/KukiSa/SKY-BOX/main/armbox.sh && chmod +x box.sh && clear && ./armbox.sh "
    yellow " =================================================="
    green " 1. 下载 IPV.SH IPv4/IPv6 优先级调整一键脚本" 
    green " 2. 下载 IPT.SH iptables 一键脚本"
    green " 3. 下载 SpeedTest for Linux 并安装为命令"
    green " 4. 下载 Rclone & Fclone 并安装为命令" 
    green " 5. 下载 ChangeSource Linux 换源脚本"
    green " 6. 下载 Besttrace 路由追踪并安装为命令"
    green " 7. 下载并安装 NEZHA.SH 哪吒面板/探针"
    yellow " --------------------------------------------------"
    green " 11. 获取本机 IP 地址"
    green " 12. 安装最新 BBR 内核（仅支持 CentOS）" 
    green " 13. 启用 BBR FQ 算法"
    green " 14. 优化系统网络配置"
    green " 15. 安装 GIT 新版（仅支持 CentOS）"
    green " 16. 宝塔面板 自动磁盘挂载工具"
    green " 17. BBR 一键管理脚本（卸载内核版本，可自行切换）" 
    green " 18. SWAP一键安装/卸载"
    yellow " --------------------------------------------------"
    green " 21. Superbench 综合测试"
    green " 22. MT.SH 流媒体解锁测试"
    green " 23. Lemonbench 综合测试"
    green " 24. UNIXbench 综合测试"
    green " 25. 三网 Speedtest 测速"
    green " 26. Memorytest 内存压力测试"
    green " 27. Route-trace 路由追踪测试"
    green " 28. YABS LINUX 综合测试"
    green " 29. Disk Test 硬盘&系统综合测试"
    green " 210.TubeCheck Google/Youtube CDN 分配节点测试"
    yellow " --------------------------------------------------"
    green " 31. MTP&TLS 一键脚本"
    green " 32. V2UI 一键脚本"
    green " 33. Aria2 最强安装与管理脚本"
    yellow " --------------------------------------------------"
    green " 41. 宝塔面板 官方版·一键安装"
    green " 42. 宝塔面板 官方版·一键更新"
    green " 43. 宝塔面板 5.9开源免费版·一键安装"
    green " 44. 宝塔面板 Hostcli 破解版·一键安装·可能仅支持CentOS"
    green " 45. 宝塔面板 Hostcli 破解版·一键转移"
    green " 46. 莉塔面板·一键安装（安装后需要更新一下）"
    green " 47. 莉塔面板·一键更新（安装后需要更新一下）"
    green " 48. 莉塔面板·CentOS专用（安装后需要更新一下）"
    green " =================================================="
    green " 99. 甲骨文ARM U20 DD Debian 10"
    green " 0. 退出脚本"
    echo
    read -p "请输入数字:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           ipvsh
	;;
        2 )
           iptsh
	;;
        3 )
           speedtest-linux
	;;
        4 )
           clonesh
	;;
        5 )
           cssh
	;;
	6 )
           gettrace
	;;
	7 )
           nezha
	;;
	11 )
           getip
	;;
	12 )
           bbrnew
	;;
	13 )
           bbrfq
	;;
	14 )
           system-best
	;;
	15 )
           yumgitsh
	;;
	16 )
           btdisk
	;;
	17 )
           tcpsh
	;;
	18 )
           swapsh
	;;
	21 )
           superbench
	;;
	22 )
           mtsh
	;;
	23 )
           Lemonbench
	;;
	24 )
           UNIXbench
	;;
	25 )
           3speed
	;;
	26 )
           memorytest
	;;
	27 )
           rtsh
	;;
	28 )
           yabssh
	;;
	29 )
           disktestsh
	;;
	210 )
	tubecheck
	;;
	31 )
           mtp
	;;
	32 )
           v2ui
	;;
        33 )
           aria
	;;
	41 )
           btnew
	;;
	42 )
           btrenew
	;;
	43 )
           btold
	;;
	44 )
           bthostcli
	;;
	45 )
           bthostcli-new
	;;
	46 )
           lt
	;;
	47 )
           lt-new
	;;
	48 )
           ltc
	;;
	99 )
            armddd10
        ;;
        0 )
            exit 1
        ;;
        * )
            clear
            red "请输入正确数字 !"
            start_menu
        ;;
    esac
}
start_menu "first"
