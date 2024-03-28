#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part3.sh
# Description: OpenWrt DIY script part 3 (After feeds install)
#

# 修改openwrt登陆地址,把下面的 10.0.0.201 修改成你想要的就可以了
sed -i 's/192.168.1.1/10.0.0.201/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# 移除要替换的包
# rm -rf feeds/packages/net/v2ray-geodata
# rm -rf feeds/third_party/luci-app-LingTiGameAcc

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件
# git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
# git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adguardhome
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openclash
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-aliddns
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-filebrowser filebrowser luci-lib-taskd
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-jellyfin

# 添加kiddin9 bypass组件
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-maxminddb
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages lua-neturl
git_sparse_clone master https://github.com/kiddin9/openwrt-packages redsocks2
# git_sparse_clone master https://github.com/kiddin9/openwrt-packages  luci-app-bypass

# 添加passwall组件
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
# git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall
# git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2


# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
$GITHUB_WORKSPACE/preset-clash-core.sh amd64

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/argon/img/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/argon/img/argon.svg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/argon.svg
cp -f $GITHUB_WORKSPACE/argon/background/background.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/background/background.jpg
cp -f $GITHUB_WORKSPACE/argon/favicon.ico feeds/third/luci-theme-argon/htdocs/luci-static/argon/favicon.ico
cp -f $GITHUB_WORKSPACE/argon/icon/android-icon-192x192.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/android-icon-192x192.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-144x144.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-144x144.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-60x60.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-60x60.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-72x72.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-72x72.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-16x16.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-16x16.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-32x32.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-32x32.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-96x96.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-96x96.png
cp -f $GITHUB_WORKSPACE/argon/icon/ms-icon-144x144.png feeds/third/luci-theme-argon/htdocs/luci-static/argon/icon/ms-icon-144x144.png


echo "
# 额外组件
CONFIG_GRUB_IMAGES=y
CONFIG_VMDK_IMAGES=y

# openclash
CONFIG_PACKAGE_luci-app-openclash=y

# adguardhome
CONFIG_PACKAGE_luci-app-adguardhome=y

# mosdns
CONFIG_PACKAGE_luci-app-mosdns=y

# pushbot
CONFIG_PACKAGE_luci-app-pushbot=y

# Jellyfin
CONFIG_PACKAGE_luci-app-jellyfin=y

# qbittorrent
CONFIG_PACKAGE_luci-app-qbittorrent=y

# transmission
CONFIG_PACKAGE_luci-app-transmission=y
CONFIG_PACKAGE_transmission-web-control=y

# uhttpd
#CONFIG_PACKAGE_luci-app-uhttpd=y

# 阿里DDNS
CONFIG_PACKAGE_luci-app-aliddns=y

# filebrowser
CONFIG_PACKAGE_luci-app-filebrowser=y

# 科学上网-passwall
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_GO=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_tuic_client=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geodata=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y

# 科学上网-passwall2
CONFIG_PACKAGE_luci-app-passwall2=y
CONFIG_PACKAGE_luci-app-passwall2_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Brook=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Haproxy is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_IPv6_Nat=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_tuic_client=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin=y

# 科学上网-bypass
CONFIG_PACKAGE_lua-maxminddb=y
CONFIG_PACKAGE_luci-app-bypass=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs_server=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray_plugin is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Trojan=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_NaiveProxy is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks5_Proxy=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks_Server=y

# npc
CONFIG_PACKAGE_luci-app-nps=y
CONFIG_PACKAGE_luci-i18n-nps-zh-cn=y

" >> .config
