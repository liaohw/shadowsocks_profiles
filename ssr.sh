#!/bin/bash

version=2.0
app="ShadowsocksX"
github_acct_url="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
# ShadowsocksX-NG
ssr_app="$app-NG"
com_ssr="com.qiuyuzhou.$ssr_app"
# ShadowsocksX-R
# ssr_app="$app-R"
# com_ssr="com.yicheng.$ssr_app"
plist="$HOME/Library/Preferences/$com_ssr.plist"
# /Users/liaohw/Library/Preferences/com.qiuyuzhou.ShadowsocksX-NG.plist

function stop_ShadowsocksX(){
    ss_process=`ps -ef |grep $ssr_app |grep -v "grep"`
    echo "$ss_process"
    if [ "$ss_process" ]; then
        pid=`echo "$ss_process" | awk '{print $2}'`
        if [ -z "$pid" ]; then
            echo "stop shadowsocks failed, please restart $ss_app manually!"
        else
            kill -9 "$pid"
            echo "停止 shadowsocks"
            stop_ShadowsocksX
        fi
    fi
}

function restart_ShadowsocksX(){
    stop_ShadowsocksX
    # ss_application="/Applications/ShadowsocksX-R.app"
    ss_application="/Applications/ShadowsocksX-NG-R8.app"
    if [ -d "$ss_application" ]; then
        open "$ss_application"
        echo "重启 $ss_application."
    fi
}

function get_github_ssa()
{
    echo "\n从github获取免费账户\n"
    # 10秒超时,默认2分钟等太久了，延迟2s重试3次
    curl --max-time 5 --retry-delay 2 --retry 3 --url "$github_acct_url" -o ssr.txt
    if [ -f ssr.txt ]; then
        echo "\n下载成功，重置配置"
        cat ssr.txt | perl ssr.pl > ssr.xml
        plutil -convert binary1 ./ssr.xml -o ./new.plist
        defaults import $com_ssr ./new.plist
        if [ $1 -eq 0 ]; then
            restart_ShadowsocksX
        fi
        rm ssr.txt ssr.xml new.plist
    else
        echo "\n下载失败！检查网络！"
    fi
}

function analysis_config()
{
    echo "\n解析服务器配置文件\n"
    plutil -convert xml1 $plist -o out.xml
    echo "解析输出到out.xml"
}

function load_config()
{
    echo "\n加载out.xml的配置\n"
    plutil -convert binary1 ./out.xml -o ./new.plist
    defaults import $com_ssr ./new.plist
    echo "\n刷新配置到服务\n"
    restart_ShadowsocksX
    rm new.plist
}

function show_help()
{
	echo "*******************************************************************"
	echo "功能说明:"
    echo "  $0 0    获取github免费账户，重启ShadowsocksX"
    echo "  $0 1    获取github免费账户"
    echo "  $0 2    重启ShadowsocksX"
    echo "  $0 3    解析服务器配置文件，写到out.xml文件输出"
    echo "  $0 4    读取xml文件刷新配置到服务，并重启ShadowsocksX"
	echo "*******************************************************************"
}

if [ "$#" -eq 1 ]; then
    opt=$1
    if [ $opt -eq "0" ] || [ $opt -eq "1" ]; then
        get_github_ssa $opt 
    elif [ $opt -eq "2" ]; then
        restart_ShadowsocksX
    elif [ $opt -eq "3" ]; then
        analysis_config
    elif [ $opt -eq "4" ]; then
        load_config
    else
        echo "arg error!"
        show_help
        exit 1;
    fi
    echo "\ndone!\n"
else
	show_help
	exit 0 ;
fi


