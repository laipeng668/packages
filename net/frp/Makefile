include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.70.1
PKG_RELEASE:=1

PKG_MAINTAINER:=Alexandru Ardelean <ardeleanalex@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

ARCH_ID:=$(strip $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(ARCH)))

ifneq (,$(filter x86_64,$(ARCH_ID)))
  PKG_ARCH:=amd64
  PKG_HASH:=333da23d1b9009d7c01638e9ba38cf4600f7d37d393f854e96ee1396adefa9a6
else ifneq (,$(filter aarch64%,$(ARCH_ID)))
  PKG_ARCH:=arm64
  PKG_HASH:=3990f396a9a490ee7f0e5f355287750ed41520064ed999eab443b5e9a78d773d
else ifneq (,$(filter arm%,$(ARCH_ID)))
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_ARCH:=arm
    PKG_HASH:=da53c7211ce3ff7b4654e3018185fdd9b4b12143184f622e85653403862f3d3c
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_ARCH:=arm
    PKG_HASH:=da53c7211ce3ff7b4654e3018185fdd9b4b12143184f622e85653403862f3d3c
  else
    PKG_ARCH:=arm_hf
    PKG_HASH:=c95214c140efe9727350c1c96b4486dbcdee6c31be2af494352beda01f97e9e2
  endif
else ifneq (,$(filter mipsel%,$(ARCH_ID)))
  PKG_ARCH:=mipsle
  PKG_HASH:=178648e0de01272c758346fde789a97dbf352dfb4744acddc634c629af054b92
else ifneq (,$(filter mips64el%,$(ARCH_ID)))
  PKG_ARCH:=mips64le
  PKG_HASH:=1d42b86d51fdf030f901ebe7e7d0cecfc96a0aa690b0eca7dbb86e1963eab543
else ifneq (,$(filter mips64%,$(ARCH_ID)))
  PKG_ARCH:=mips64
  PKG_HASH:=1ff7f353667e6643727edd4d6488b1d9e3371cda42d8d7288787b44f8d7875b6
else ifneq (,$(filter mips%,$(ARCH_ID)))
  PKG_ARCH:=mips
  PKG_HASH:=23d4d42d868a0a21cc676b3d2fb9f98f067c5416ba135820696c0aeeaca3da50
else ifneq (,$(filter loongarch64%,$(ARCH_ID)))
  PKG_ARCH:=loong64
  PKG_HASH:=4defcc084778a6209a2cf50786a49837bb11ed474b6f185a7c2799775521e150
else ifneq (,$(filter riscv64%,$(ARCH_ID)))
  PKG_ARCH:=riscv64
  PKG_HASH:=e6eb6118b11b087e70cef1a398fbfa239e16a40c67693870dbda9540947e9070
endif

PKG_SOURCE:=frp_$(PKG_VERSION)_linux_$(PKG_ARCH).tar.gz
PKG_SOURCE_URL:=https://github.com/fatedier/frp/releases/download/v$(PKG_VERSION)/
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	tar -xzf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_DIR) --strip-components=1
endef

define Build/Compile
	true
endef

define Package/frp/install
	$(INSTALL_DIR) $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_DIR) $(1)/etc/frp/$(2).d/
	$(INSTALL_DIR) $(1)/etc/init.d/

	$(INSTALL_CONF) ./files/$(2).config $(1)/etc/config/$(2)
	$(INSTALL_BIN)  ./files/$(2).init   $(1)/etc/init.d/$(2)
	$(INSTALL_BIN)  ./files/$(2).init   $(1)/etc/init.d/$(2)

	if [ -r ./files/$(2).uci-defaults ]; then \
		$(INSTALL_DIR) $(1)/etc/uci-defaults; \
		$(INSTALL_DATA) ./files/$(2).uci-defaults $(1)/etc/uci-defaults/$(2); \
	fi

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(2) $(1)/usr/bin/
endef

define Package/frp/template
  define Package/$(1)
    SECTION:=net
    CATEGORY:=Network
    SUBMENU:=Web Servers/Proxies
    TITLE:=$(1) - fast reverse proxy $(2)
    URL:=https://github.com/fatedier/frp
    DEPENDS:=@(x86_64||aarch64||arm||mips||mips64||mips64el||mipsel||loongarch64||riscv64)
  endef

  define Package/$(1)/description
    $(1) is a fast reverse proxy $(2) that helps you expose a local server
    behind a NAT or firewall to the internet.

    This package uses precompiled binaries from official frp releases.
    Supported architectures: x86_64, aarch64, arm, mips*, loongarch64, riscv64.
  endef

  define Package/$(1)/conffiles
/etc/config/$(1)
/etc/frp/$(1).d/
  endef

  define Package/$(1)/install
    $(call Package/frp/install,$$(1),$(1))
  endef
endef

$(eval $(call Package/frp/template,frpc,client))
$(eval $(call Package/frp/template,frps,server))
$(eval $(call BuildPackage,frpc))
$(eval $(call BuildPackage,frps))
