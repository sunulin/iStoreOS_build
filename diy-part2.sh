#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 删除冲突软件库

rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/third_party/luci-app-LingTiGameAcc
rm -rf feeds/third_party/qBittorrent-static
rm -rf feeds/small/shadowsocksr-libev

rm -rf feeds/packages/net/{alist,adguardhome,xray*,v2ray*,sing*,smartdns,trojan*}
rm -rf feeds/packages/utils/v2dat

cp -rf feeds/kenzo/adguardhome feeds/packages/net/
cp -rf feeds/kenzo/smartdns feeds/packages/net/
cp -rf feeds/small/v2dat feeds/packages/utils/
cp -rf feeds/small/xray-core feeds/packages/net/
cp -rf feeds/small/xray-plugin feeds/packages/net/
cp -rf feeds/small/v2ray-plugin feeds/packages/net/
cp -rf feeds/small/v2ray-geodata feeds/packages/net/
cp -rf feeds/small/v2ray-core feeds/packages/net/
cp -rf feeds/small/sing-box feeds/packages/net/
# 添加passwall依赖库
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages feeds/passwall-packages

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
