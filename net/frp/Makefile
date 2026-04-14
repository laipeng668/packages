include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.68.1
PKG_RELEASE:=1

PKG_MAINTAINER:=
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

ARCH_ID:=$(strip $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(ARCH)))

ifneq (,$(filter x86_64,$(ARCH_ID)))
  PKG_ARCH:=amd64
  PKG_HASH:=4a4e88987d39561e1b3b3b23d0ede48a457eebf76a87231999957e870f5f02b6
else ifneq (,$(filter aarch64%,$(ARCH_ID)))
  PKG_ARCH:=arm64
  PKG_HASH:=e7ad15b0cfe4cf0125df4217778b66cb4426179270967b59900ecb2362d8cd01
else ifneq (,$(filter arm%,$(ARCH_ID)))
  PKG_ARCH:=arm
  PKG_HASH:=50b187e66c1b9366532bda25326ca75e2f0dffbb474431310321a705cea9810f
else ifneq (,$(filter mipsel%,$(ARCH_ID)))
  PKG_ARCH:=mipsle
  PKG_HASH:=097ad98dd165c028577064e9b7277de652c2649efaf8f6e835ab4510bce93ddf
else ifneq (,$(filter mips64el%,$(ARCH_ID)))
  PKG_ARCH:=mips64le
  PKG_HASH:=928f57c0f29c3fdede305144f62e5eb557fe10120775ed43c204c4fa9cfd220b
else ifneq (,$(filter mips64%,$(ARCH_ID)))
  PKG_ARCH:=mips64
  PKG_HASH:=be64ee6f168ec038064a4a2c96aa3b5fbba96463668095bcb0491280314a4e84
else ifneq (,$(filter mips%,$(ARCH_ID)))
  PKG_ARCH:=mips
  PKG_HASH:=3393effe2937b9d92e9b2489fa8c64e860ffd028e119017f72bc1f538c0773f9
else ifneq (,$(filter loongarch64%,$(ARCH_ID)))
  PKG_ARCH:=loong64
  PKG_HASH:=8f69cd6707b9c90b8e291879b1bfe2465056464ef770c4f95a2b3ee6a9489dd5
else ifneq (,$(filter riscv64%,$(ARCH_ID)))
  PKG_ARCH:=riscv64
  PKG_HASH:=95e0924b54e90d607ef4b70b6ce27b26c73de2f4fbebeab2c97a849863918a52
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
	$(INSTALL_DIR) $(1)/etc/init.d/

	$(INSTALL_CONF) ./files/$(2).config $(1)/etc/config/$(2)
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
  endef

  define Package/$(1)/description
    $(1) is a fast reverse proxy $(2) that helps you expose a local server
    behind a NAT or firewall to the internet.

    This package uses precompiled binaries from official frp releases.
    Supported architectures: x86_64, aarch64, arm, mips*, loongarch64, riscv64.
  endef

  define Package/$(1)/conffiles
/etc/config/$(1)
  endef

  define Package/$(1)/install
    $(call Package/frp/install,$$(1),$(1))
  endef
endef

$(eval $(call Package/frp/template,frpc,client))
$(eval $(call Package/frp/template,frps,server))
$(eval $(call BuildPackage,frpc))
$(eval $(call BuildPackage,frps))
