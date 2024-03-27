#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 删除冲突软件库

rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/{alist,adguardhome,xray*,v2ray*,v2ray*,sing*,smartdns,trojan*}
rm -rf feeds/third_party/luci-app-LingTiGameAcc

cp -f feeds/kenzo/adguardhome feeds/packages/net/adguardhome
cp -f feeds/kenzo/smartdns feeds/packages/net/smartdns

# 添加passwall依赖库
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/passwall-packages

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
