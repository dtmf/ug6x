include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8189fs
PKG_RELEASE:=1

PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=

PKG_SOURCE_URL:=https://github.com/jwrdegoede/rtl8189ES_linux.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2023-03-27
PKG_SOURCE_VERSION:=c223a25b1000d64432eca4201a8f012414dfc7ce
PKG_MIRROR_HASH:=45df4c33d94ce17e8e06785604f1c231f17b5670ceb464a47ddeeae0a2147f73
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rtl8189fs
  SUBMENU:=Wireless Drivers
  TITLE:=Realtec RTL8189FS support
  FILES:=$(PKG_BUILD_DIR)/8189fs.ko
  DEPENDS:=+@DRIVER_11AC_SUPPORT
  AUTOLOAD:=$(call AutoProbe,8189fs)
  PROVIDES:=kmod-rtl8189fs
endef

define Package/rtl8189fs/description
  RTL8189FS Driver
endef

ifdef CONFIG_PACKAGE_MAC80211_MESH
  NOSTDINC_FLAGS += -DCONFIG_MAC80211_MESH
endif

NOSTDINC_FLAGS+=-DCONFIG_CONCURRENT_MODE -DRTW_USE_CFG80211_STA_EVENT -DCONFIG_DEBUG_CFG80211 -DCONFIG_IOCTL_CFG80211

define Build/Compile
	$(MAKE) \
	-C $(PKG_BUILD_DIR) \
	src=$(PKG_BUILD_DIR) \
	ARCH=$(LINUX_KARCH) \
	CROSS_COMPILE="aarch64-openwrt-linux-musl-" \
	KSRC=$(LINUX_DIR) \
	M="$(PKG_BUILD_DIR)" \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
	modules
endef

## the following files copied from package/kernel/mac80211
#define KernelPackage/rtl8189fs/install
#	$(INSTALL_DIR) $(1)/lib/wifi $(1)/lib/netifd/wireless
#	$(INSTALL_DATA) ./files/lib/wifi/mac80211.sh $(1)/lib/wifi
#	$(INSTALL_BIN) ./files/lib/netifd/wireless/mac80211.sh $(1)/lib/netifd/wireless
#	$(INSTALL_DIR) $(1)/etc/hotplug.d/ieee80211
#	$(INSTALL_DATA) ./files/mac80211.hotplug $(1)/etc/hotplug.d/ieee80211/10-wifi-detect
#endef

$(eval $(call KernelPackage,rtl8189fs))
