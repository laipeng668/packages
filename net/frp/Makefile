include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.69.1
PKG_RELEASE:=1

PKG_MAINTAINER:=
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

ARCH_ID:=$(strip $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(ARCH)))

ifneq (,$(filter x86_64,$(ARCH_ID)))
  PKG_ARCH:=amd64
  PKG_HASH:=7be257b72dbbc60bcb3e0e25a5afd1dfac7b63f897084864d3c956dd3d5674e1
else ifneq (,$(filter aarch64%,$(ARCH_ID)))
  PKG_ARCH:=arm64
  PKG_HASH:=bbc0c75e896af3f292fb46ba09c844a04fa9b5ea3530c039c7af20637f836355
else ifneq (,$(filter arm%,$(ARCH_ID)))
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_ARCH:=arm
    PKG_HASH:=a4e5100d6f5cbbbec3cb364e2322a17c124966e10df388c6d0055523d7e12382
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_ARCH:=arm
    PKG_HASH:=a4e5100d6f5cbbbec3cb364e2322a17c124966e10df388c6d0055523d7e12382
  else
    PKG_ARCH:=arm_hf
    PKG_HASH:=8e0b4eaf92fd783d403bb4f4b540404b633f4bf89a290dc211c837d8165411a8
  endif
else ifneq (,$(filter mipsel%,$(ARCH_ID)))
  PKG_ARCH:=mipsle
  PKG_HASH:=b72a7342aa865ccf9f24b8bd552eea78f54d759af2bed5b8f4cec4744ef76d66
else ifneq (,$(filter mips64el%,$(ARCH_ID)))
  PKG_ARCH:=mips64le
  PKG_HASH:=d74c98c2ccf6c1589341fdc9fd0ca8663bb60fa9a8e27940c4c307f5390f5dbc
else ifneq (,$(filter mips64%,$(ARCH_ID)))
  PKG_ARCH:=mips64
  PKG_HASH:=7771eaede4bffb4f557b74e865df8dcacb106e32648abceb09a6822fca1a029e
else ifneq (,$(filter mips%,$(ARCH_ID)))
  PKG_ARCH:=mips
  PKG_HASH:=6dbd1dbb322e7febcdb10ba0ce2a90bfb4ad10c5c4914af06f2cefc461d994d9
else ifneq (,$(filter loongarch64%,$(ARCH_ID)))
  PKG_ARCH:=loong64
  PKG_HASH:=ae4cf33dcb58707754eb5e6f77cc265fad869b6be970c26ba7e2491d5dac88b6
else ifneq (,$(filter riscv64%,$(ARCH_ID)))
  PKG_ARCH:=riscv64
  PKG_HASH:=c0f95a2dc1704b60618f91c905e47f014b854a41fcde2dac1722330528399777
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
  endef

  define Package/$(1)/install
    $(call Package/frp/install,$$(1),$(1))
  endef
endef

$(eval $(call Package/frp/template,frpc,client))
$(eval $(call Package/frp/template,frps,server))
$(eval $(call BuildPackage,frpc))
$(eval $(call BuildPackage,frps))
