#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 删除冲突软件库

rm -rf package/feeds/luci/applications/luci-app-mosdns
rm -rf package/feeds/third_party/luci-app-LingTiGameAcc

rm -rf package/feeds/packages/net/{alist,adguardhome,xray*,v2ray*,v2ray*,sing*,smartdns,trojan*}
cp -f package/feeds/kenzo/adguardhome package/feeds/packages/net/adguardhome
cp -f package/feeds/kenzo/smartdns package/feeds/packages/net/smartdns

# 添加passwall依赖库
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/feeds/passwall-packages

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang package/feeds/packages/lang/golang
