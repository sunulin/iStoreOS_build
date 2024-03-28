#!/bin/bash
#
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# 删除冲突软件库

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/third_party/luci-app-LingTiGameAcc

rm -rf feeds/packages/net/{alist,adguardhome,xray*,v2ray*,v2ray*,sing*,smartdns,trojan*}
git_sparse_clone master  https://github.com/kenzok8/openwrt-packages adguardhome smartdns
mv -f package/adguardhome package/feeds/packages/net
mv -f package/smartdns package/feeds/packages/net

# 添加passwall依赖库
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages feeds/passwall-packages

# 替换golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
