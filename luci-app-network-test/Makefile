include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-network-test
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=Network Latency Test Tool
LUCI_DEPENDS:=+luci-base +fping
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/install
    # 安装Lua控制器
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin
    $(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/admin/network-test.lua $(1)/usr/lib/lua/luci/controller/admin/

    # 安装视图模板
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
    $(INSTALL_DATA) ./files/usr/lib/lua/luci/view/network-test.htm $(1)/usr/lib/lua/luci/view/

    # 安装初始化脚本
    $(INSTALL_DIR) $(1)/etc/uci-defaults
    $(INSTALL_BIN) ./root/etc/uci-defaults/luci-network-test $(1)/etc/uci-defaults/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
