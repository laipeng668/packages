#
# Copyright (C) 2007-2019 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python-pytz
PKG_VERSION:=2025.2
PKG_RELEASE:=1

PYPI_NAME:=pytz
PKG_HASH:=360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3

PKG_MAINTAINER:=Alexandru Ardelean <ardeleanalex@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE.txt

include ../pypi.mk
include $(INCLUDE_DIR)/package.mk
include ../python3-package.mk

define Package/python3-pytz
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=World timezone definitions, modern and historical
  URL:=https://pythonhosted.org/pytz/
  DEPENDS:=+python3-light
endef

define Package/python3-pytz/description
  World timezone definitions, modern and historical
endef

$(eval $(call Py3Package,python3-pytz))
$(eval $(call BuildPackage,python3-pytz))
$(eval $(call BuildPackage,python3-pytz-src))
