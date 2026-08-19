include $(TOPDIR)/rules.mk

PKG_NAME:=frp
PKG_VERSION:=0.71.0
PKG_RELEASE:=1

PKG_MAINTAINER:=Alexandru Ardelean <ardeleanalex@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

ARCH_ID:=$(strip $(if $(ARCH_PACKAGES),$(ARCH_PACKAGES),$(ARCH)))

ifneq (,$(filter x86_64,$(ARCH_ID)))
  PKG_ARCH:=amd64
  PKG_HASH:=84f27e39f11169f7adcef8e8b70c9329de17747b1f14dad9fb95eef5682ea716
else ifneq (,$(filter aarch64%,$(ARCH_ID)))
  PKG_ARCH:=arm64
  PKG_HASH:=f33c293c275d8fc68c654b6fba8f10b2551d6463d09a9fc9cffb7227eae82266
else ifneq (,$(filter arm%,$(ARCH_ID)))
  ARM_CPU_FEATURES:=$(word 2,$(subst +,$(space),$(call qstrip,$(CONFIG_CPU_TYPE))))
  ifeq ($(ARM_CPU_FEATURES),)
    PKG_ARCH:=arm
    PKG_HASH:=f40a984f83e8d34a9241b0be4a9d5fbcfe513a4a5c022b84a02637ff6d36833b
  else ifneq ($(filter $(ARM_CPU_FEATURES),vfp vfpv2),)
    PKG_ARCH:=arm
    PKG_HASH:=f40a984f83e8d34a9241b0be4a9d5fbcfe513a4a5c022b84a02637ff6d36833b
  else
    PKG_ARCH:=arm_hf
    PKG_HASH:=eab1ecb45b00e2f9cf2ebc458fde570ceecb50689c4c5c728677f44825bf3d88
  endif
else ifneq (,$(filter mipsel%,$(ARCH_ID)))
  PKG_ARCH:=mipsle
  PKG_HASH:=14498e36554a275a9d41a61aa29680616a34c7c9d8914e2173a46dada4928c70
else ifneq (,$(filter mips64el%,$(ARCH_ID)))
  PKG_ARCH:=mips64le
  PKG_HASH:=adcd256a6fa5c96985a1ddd02e0e759fc054fa3e858748055d7e49e80f51c68f
else ifneq (,$(filter mips64%,$(ARCH_ID)))
  PKG_ARCH:=mips64
  PKG_HASH:=3d336925e8bbba313d956b04d59e2dcf301f169304bbc105340133bc3e524451
else ifneq (,$(filter mips%,$(ARCH_ID)))
  PKG_ARCH:=mips
  PKG_HASH:=dd3fb404b546f215848db466c5707f501bcc2e24f605228f52e2a1546904a29d
else ifneq (,$(filter loongarch64%,$(ARCH_ID)))
  PKG_ARCH:=loong64
  PKG_HASH:=e5f4d7e25b677cca885f3db5cc958441bfa12e7214e05304601331ac3d84cebc
else ifneq (,$(filter riscv64%,$(ARCH_ID)))
  PKG_ARCH:=riscv64
  PKG_HASH:=92b48d5e4d44d2f1415fde24489d3dfff5badbd52ddf7e816467cdcaa973aa5c
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
