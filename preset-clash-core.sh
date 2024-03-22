#!/bin/bash
#=================================================
# File name: perest-clash-core.sh

# System Required: Linux
# Version: 1.0
# Lisence: MIT
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

echo -e "预置Clash内核"

mkdir -p package/luci-app-openclash/root/etc/openclash/core
core_path="packageluci-app-openclash/root/etc/openclash/core"
goe_path="packageluci-app-openclash/root/etc/openclash"

mkdir -p files/usr/share/openclash/ui/yacd
mkdir -p files/usr/share/openclash/ui/dashboard
mkdir -p files/usr/share/openclash/ui/metacubexd

CORE_VERSION="$(curl -fsSL https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version | grep '^[0-9].*')"

CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/dev/clash-linux-${1}.tar.gz"
CLASH_TUN_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/premium/clash-linux-${1}-${CORE_VERSION}.gz"
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/meta/clash-linux-${1}.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
YACD_META_URL="https://raw.githubusercontent.com/DustinWin/clash-tools/main/Clash-dashboard/Yacd-meta.tar.gz"
RAZORD_META_URL="https://raw.githubusercontent.com/DustinWin/clash-tools/main/Clash-dashboard/Razord-meta.tar.gz"
METACUBEXD_META_URL="https://raw.githubusercontent.com/DustinWin/clash-tools/main/Clash-dashboard/metacubexd.tar.gz"




wget -qO- $CLASH_DEV_URL | tar xOvz > $core_path/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > $core_path/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > $core_path/clash_meta
wget -qO- $GEOIP_URL > $goe_path/GeoIP.dat
wget -qO- $GEOSITE_URL > $goe_path/GeoSite.dat
wget -qO- $YACD_META_URL | tar xvz -C files/usr/share/openclash/ui/yacd
wget -qO- $RAZORD_META_URL | tar xvz -C files/usr/share/openclash/ui/dashboard
wget -qO- $METACUBEXD_META_URL | tar xvz -C files/usr/share/openclash/ui/metacubexd


chmod +x $core_path/clash*