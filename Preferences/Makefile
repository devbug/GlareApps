FW_DEVICE_IP = 192.168.1.9

ARCHS = armv7 armv7s arm64
SDKVERSION = 7.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0

include theos/makefiles/common.mk

BUNDLE_NAME = GlareAppsSettings
GlareAppsSettings_FILES = GlareAppsSettings.m \
						  ../../FilteredAppListTableView/PSFilteredAppListCell.m \
						  ../../FilteredAppListTableView/PSFilteredAppListListController.m
GlareAppsSettings_INSTALL_PATH = /Library/PreferenceBundles
GlareAppsSettings_FRAMEWORKS = UIKit QuartzCore CoreGraphics
GlareAppsSettings_PRIVATE_FRAMEWORKS = Preferences SpringBoardServices

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/GlareAppsSettings.plist$(ECHO_END)

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "mkdir -p /Library/PreferenceBundles/$(BUNDLE_NAME).bundle/"
	ssh root@$(FW_DEVICE_IP) "mkdir -p /Library/PreferenceBundles/$(BUNDLE_NAME).bundle/en.lproj/"
	ssh root@$(FW_DEVICE_IP) "mkdir -p /Library/PreferenceBundles/$(BUNDLE_NAME).bundle/ko.lproj/"
	scp "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(BUNDLE_NAME).bundle/$(BUNDLE_NAME)" root@$(FW_DEVICE_IP):/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/
	scp "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(BUNDLE_NAME).bundle/Info.plist" root@$(FW_DEVICE_IP):/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/
	scp "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(BUNDLE_NAME).bundle/en.lproj/GlareAppsSettings.strings" root@$(FW_DEVICE_IP):/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/en.lproj/
	scp "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(BUNDLE_NAME).bundle/ko.lproj/GlareAppsSettings.strings" root@$(FW_DEVICE_IP):/Library/PreferenceBundles/$(BUNDLE_NAME).bundle/ko.lproj/
after-remoteinstall::
	ssh root@$(FW_DEVICE_IP) "killall -9 Preferences"
