#
# Copyright (C) 2019-2021 CZ.NIC z.s.p.o. (http://www.nic.cz/)
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=libmaxminddb
PKG_VERSION:=1.11.0
PKG_RELEASE=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/maxmind/libmaxminddb/releases/download/$(PKG_VERSION)
PKG_HASH:=b2eea79a96fed77ad4d6c39ec34fed83d45fcb75a31c58956813d58dcf30b19f

PKG_MAINTAINER:=Jan Pavlinec <jan.pavlinec1@gmail.com>
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_CPE_ID:=cpe:/a:maxmind:libmaxminddb

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/libmaxminddb
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=A library for working with MaxMind DB files
  URL:=https://maxmind.github.io/libmaxminddb/
endef

define Package/libmaxminddb/description
 The libmaxminddb library provides functions for working MaxMind DB files.
endef

CMAKE_OPTIONS += \
	-DBUILD_SHARED_LIBS=ON \
	-DBUILD_TESTING=OFF

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/* $(1)/usr/include/
	$(INSTALL_DIR) $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmaxminddb.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libmaxminddb.pc $(1)/usr/lib/pkgconfig
	$(SED) 's,libdir=lib,libdir=$$$${exec_prefix}/lib,g' $(1)/usr/lib/pkgconfig/libmaxminddb.pc
	$(SED) 's,includedir=include,includedir=$$$${prefix}/include,g' $(1)/usr/lib/pkgconfig/libmaxminddb.pc
endef

define Package/libmaxminddb/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mmdblookup $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libmaxminddb.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libmaxminddb))
