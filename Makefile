
PWD=$(shell pwd)

TARGET_MAKEFILE=Makefile

all: build

init:
	git submodule update --init --recursive aap-juce
	git submodule update --init --recursive android-audio-plugin-framework 
	git submodule update --init --recursive JUCE
	cd apps/aap-juce-adlplug && git submodule update --init --recursive external/ADLplug
	cd apps/aap-juce-dexed && git submodule update --init --recursive external/dexed
	cd apps/aap-juce-obxd && git submodule update --init --recursive external/OB-Xd
	cd apps/aap-juce-ports && git submodule update --init --recursive external/andes
	cd apps/aap-juce-ports && git submodule update --init --recursive external/SARAH
	cd apps/aap-juce-ports && git submodule update --init --recursive external/Magical8bitPlug2

dist:
	mkdir -p release-builds
	make TARGET=aap-juce-plugin-host distone
	make TARGET=aap-juce-adlplug distone
	make TARGET=aap-juce-dexed distone
	make TARGET=aap-juce-obxd distone
	make TARGET=aap-juce-ports distone

distone:
	make -C apps/$(TARGET) AAP_JUCE_DIR=$(PWD)/aap-juce DIST_DIR=$(PWD)/release-builds dist

build: build-apps

build-aap:
	make -C $(PWD)/android-audio-plugin-framework

build-apps: \
	build-pluginhost \
	build-adlplug \
	build-dexed \
	build-obxd \
	build-other-ports

build-other-ports: build-andes build-sarah build-magical8bitplug2

# arguments:
# - APP_TARGET
# - APP_SRC_DIR
# - TARGET_MAKEFILE
build-single-app:
	cd $(APP_TARGET) && make \
		APP_SRC_DIR=$(APP_SRC_DIR) \
		AAP_JUCE_DIR=$(PWD)/aap-juce \
		JUCE_DIR=$(PWD)/JUCE \
		AAP_DIR=$(PWD)/android-audio-plugin-framework \
		-f $(TARGET_MAKEFILE)

build-pluginhost:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-plugin-host \
		APP_SRC_DIR=$(PWD)/JUCE/extras/AudioPluginHost \
		build-single-app

build-adlplug:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-adlplug \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-adlplug/external/ADLplug \
		build-single-app

build-dexed:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-dexed \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-dexed/external/dexed \
		build-single-app

build-obxd:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-obxd \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-obxd/external/OB-Xd \
		build-single-app

build-andes:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-ports \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-ports/external/andes \
		TARGET_MAKEFILE=Makefile.andes \
		build-single-app

build-sarah:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-ports \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-ports/external/SARAH \
		TARGET_MAKEFILE=Makefile.sarah \
		build-single-app

build-magical8bitplug2:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-ports \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-ports/external/Magical8bitPlug2 \
		TARGET_MAKEFILE=Makefile.magical8bitplug2 \
		build-single-app
