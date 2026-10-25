include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.71.1
PKG_RELEASE:=1

PKG_MAINTAINER:=Alexandru Ardelean <ardeleanalex@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

ARCH_ID:=$(strip $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(ARCH)))

ifneq (,$(filter x86_64,$(ARCH_ID)))
  PKG_ARCH:=amd64
  PKG_HASH:=1d9875210972a5d1a62b2dc4c48df45ab0af05d3ca1b5e494a014428259df803
else ifneq (,$(filter aarch64%,$(ARCH_ID)))
  PKG_ARCH:=arm64
  PKG_HASH:=8edf590b0c396fa42f9c147121a76af83cfc2002b08f5aef0ea1008c43482019
else ifneq (,$(filter arm%,$(ARCH_ID)))
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_ARCH:=arm
    PKG_HASH:=8eb6fe66a3b36db24ca0de44fb01e6742d0ff60e30f462c9662f41813bbf4376
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_ARCH:=arm
    PKG_HASH:=8eb6fe66a3b36db24ca0de44fb01e6742d0ff60e30f462c9662f41813bbf4376
  else
    PKG_ARCH:=arm_hf
    PKG_HASH:=a40116f15f2a05b7001f985f1f1ccb2570e2aa41329b06de76a82e71495786db
  endif
else ifneq (,$(filter mipsel%,$(ARCH_ID)))
  PKG_ARCH:=mipsle
  PKG_HASH:=2eaa97e6b42a0cbd672b079b59d5682bb64a766f9a9564d7c4bbbd3ca79ec694
else ifneq (,$(filter mips64el%,$(ARCH_ID)))
  PKG_ARCH:=mips64le
  PKG_HASH:=5cbdcc65fab851ab8f340df7b4539c2b2dbe74a365e41af2cb380712f07bea94
else ifneq (,$(filter mips64%,$(ARCH_ID)))
  PKG_ARCH:=mips64
  PKG_HASH:=277089dc9f2b5f688ced1117002eef8ce7cb508c225c7981423db772af97c7ec
else ifneq (,$(filter mips%,$(ARCH_ID)))
  PKG_ARCH:=mips
  PKG_HASH:=cb13debcd3df1b53efb229dbd0507f1f594c481ab4a2a89c6254e7df23141b5d
else ifneq (,$(filter loongarch64%,$(ARCH_ID)))
  PKG_ARCH:=loong64
  PKG_HASH:=1e2fb9e17112dbc3c3d9b7ca36a23c1a97e277d6934c7a2d06faf14788e3f40a
else ifneq (,$(filter riscv64%,$(ARCH_ID)))
  PKG_ARCH:=riscv64
  PKG_HASH:=b3ade396d55d11bc1c3ceb27b22bfb6e80f3ffb5932cef29393a3d3273bab070
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
