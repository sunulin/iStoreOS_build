#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 删除冲突软件库

rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/{alist,adguardhome,xray*,v2ray*,v2ray*,sing*,smartdns}
rm -rf feeds/third_party/luci-app-LingTiGameAcc

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
