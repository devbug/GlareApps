FW_DEVICE_IP = 192.168.1.9

ARCHS = armv7 armv7s arm64

SUBPROJECTS = Preferences

include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk

TWEAK_NAME = GlareApps
GlareApps_FILES = Tweak.xm \
				  GlareAppsColorHelper.mm \
				  com.apple.springboard.xm \
				  AppliedPrograms/com.apple.Preferences.xm \
				  AppliedPrograms/com.apple.mobilephone.xm \
				  AppliedPrograms/com.apple.mobileslideshow.xm \
				  AppliedPrograms/com.apple.Music.xm \
				  AppliedPrograms/com.apple.mobiletimer.xm \
				  AppliedPrograms/com.apple.AppStore.xm \
				  AppliedPrograms/com.apple.stocks.xm \
				  AppliedPrograms/com.apple.calculator.xm \
				  AppliedPrograms/com.apple.MobileSMS.xm
GlareApps_FRAMEWORKS = UIKit CoreGraphics QuartzCore
GlareApps_PRIVATE_FRAMEWORKS = MobileTimer SpringBoardServices BackBoardServices

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

ri:: remoteinstall
remoteinstall:: all internal-remoteinstall after-remoteinstall
internal-remoteinstall::
	scp -P 22 "$(FW_PROJECT_DIR)/$(THEOS_OBJ_DIR_NAME)/$(TWEAK_NAME).dylib" root@$(FW_DEVICE_IP):/Library/MobileSubstrate/DynamicLibraries/
	scp -P 22 "$(FW_PROJECT_DIR)/$(TWEAK_NAME).plist" root@$(FW_DEVICE_IP):/Library/MobileSubstrate/DynamicLibraries/
after-remoteinstall::
#	ssh root@$(FW_DEVICE_IP) "killall -9 Preferences; exit 0"
