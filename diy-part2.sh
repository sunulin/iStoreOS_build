#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# 修改openwrt登陆地址,把下面的 10.0.0.201 修改成你想要的就可以了
sed -i 's/192.168.1.1/10.0.0.201/g' package/base-files/files/bin/config_generate

# 修改主机名字，把 iStore OS 修改你喜欢的就行（不能纯数字或者使用中文）
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# 更改 Argon 主题背景
# cp -f $GITHUB_WORKSPACE/bg1.jpg package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 移除要替换的包
#rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/v2ray-geodata
#cp -r -f ./feeds/第三方源的文件 ./feeds/packages/net/mosdns
rm -rf feeds/third_party/luci-app-LingTiGameAcc
rm -rf feeds/third_party/luci-app-pushbot
rm -rf feeds/third/luci-theme-argon

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}
#替换prometheus-node-exporter-lua
#git clone https://github.com/openwrt/packages -b openwrt-23.05 feeds/op_packages
#rm -rf feeds/packages/prometheus-node-exporter-lua
#cp  -r -f ./feeds/op_packages/utils/prometheus-node-exporter-lua ./feeds/packages/utils/prometheus-node-exporter-lua
#rm -rf feeds/op_packages

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 22.x feeds/packages/lang/golang

# 添加额外插件
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot
git clone https://github.com/innmonkey/luci-theme-argon package/luci-theme-argon
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-adguardhome
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-openclash
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-aliddns

git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall luci-app-passwall
git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 luci-app-passwall2
git_sparse_clone master https://github.com/kiddin9/openwrt-packages  luci-app-bypass

# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
$GITHUB_WORKSPACE/preset-clash-core.sh amd64


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
CONFIG_PACKAGE_app-meta-jellyfin=y
CONFIG_PACKAGE_luci-i18n-jellyfin-zh-cn=y

# qbittorrent
CONFIG_PACKAGE_luci-app-qbittorrent=y

# transmission
CONFIG_PACKAGE_luci-app-transmission=y
CONFIG_PACKAGE_transmission-daemon=y
CONFIG_PACKAGE_luci-i18n-transmission-zh-cn=y
CONFIG_PACKAGE_app-meta-transmission=y
CONFIG_PACKAGE_transmission-web-control=y
CONFIG_PACKAGE_transmission-daemon-openssl=y

# uhttpd
CONFIG_PACKAGE_luci-app-uhttpd=y

# 阿里DDNS
CONFIG_PACKAGE_luci-app-aliddns=y

# rclone
#CONFIG_PACKAGE_rclone=y
#CONFIG_PACKAGE_fuse3-utils=y

# 科学上网-passwall
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Brook=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy is not set
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy=y
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
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin=y
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
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_NaiveProxy=y
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Shadowsocks_Rust_Server is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_Simple_Obfs=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_SingBox=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_tuic_client=y
CONFIG_PACKAGE_luci-app-passwall2_INCLUDE_V2ray_Plugin=y

# 科学上网-bypass
CONFIG_PACKAGE_lua-maxminddb=y
CONFIG_PACKAGE_luci-app-bypass=y
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Shadowsocks_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-bypass_INCLUDE_ShadowsocksR_Libev_Server is not set
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Simple_obfs_server=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_V2ray_plugin=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Xray=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Trojan=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_NaiveProxy=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Kcptun=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Hysteria=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks5_Proxy=y
CONFIG_PACKAGE_luci-app-bypass_INCLUDE_Socks_Server=y

# npc
CONFIG_PACKAGE_luci-app-nps=y
CONFIG_PACKAGE_luci-i18n-nps-zh-cn=y

" >> .config
