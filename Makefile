FW_DEVICE_IP = 192.168.1.9

ARCHS = armv7 armv7s arm64

SUBPROJECTS = Preferences

include theos/makefiles/common.mk
include theos/makefiles/aggregate.mk

TWEAK_NAME = GlareApps
GlareApps_FILES = Tweak.xm \
				  com.apple.Preferences.xm \
				  com.apple.mobilephone.xm \
				  com.apple.mobileslideshow.xm \
				  com.apple.Music.xm \
				  com.apple.mobiletimer.xm \
				  com.apple.AppStore.xm \
				  com.apple.stocks.xm \
				  com.apple.calculator.xm
GlareApps_FRAMEWORKS = UIKit CoreGraphics QuartzCore
GlareApps_PRIVATE_FRAMEWORKS = MobileTimer

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
