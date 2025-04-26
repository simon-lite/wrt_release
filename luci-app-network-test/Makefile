include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk

PKG_NAME:=luci-app-network-test
PKG_VERSION:=1.0
PKG_RELEASE:=1

LUCI_TITLE:=Network Latency Test Tool
LUCI_DEPENDS:=+luci-base +fping
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# 注意：以下每行命令前必须是 TAB 缩进（不是空格）
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller/admin
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/admin/network-test.lua $(1)/usr/lib/lua/luci/controller/admin/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/view/network-test.htm $(1)/usr/lib/lua/luci/view/
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/luci-network-test $(1)/etc/uci-defaults/
endef

# 必须添加这行调用
$(eval $(call BuildPackage,$(PKG_NAME)))
