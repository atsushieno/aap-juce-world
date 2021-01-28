
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
	cd apps/aap-juce-frequalizer && git submodule update --init --recursive external/Frequalizer
	cd apps/aap-juce-odin2 && git submodule update --init --recursive external/odin2
	cd apps/aap-juce-witte-eq && git submodule update --init --recursive external/Eq
	cd apps/aap-juce-chow-phaser && git submodule update --init --recursive external/ChowPhaser

dist:
	mkdir -p release-builds
	make TARGET=aap-juce-plugin-host distone
	make TARGET=aap-juce-ports distone
	make TARGET=aap-juce-adlplug distone
	make TARGET=aap-juce-dexed distone
	make TARGET=aap-juce-obxd distone
	make TARGET=aap-juce-frequalizer distone
	make TARGET=aap-juce-odin2 distone
	make TARGET=aap-juce-witte-eq distone
	make TARGET=aap-juce-chow-phaser distone

distone:
	make -C apps/$(TARGET) AAP_JUCE_DIR=$(PWD)/aap-juce DIST_DIR=$(PWD)/release-builds dist

build: build-apps

build-aap:
	make -C $(PWD)/android-audio-plugin-framework

build-apps: \
	build-pluginhost \
	build-other-ports \
	build-adlplug \
	build-dexed \
	build-obxd \
	build-frequalizer \
	build-odin2 \
	build-witte-eq \
	build-chow-phaser

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

build-frequalizer:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-frequalizer \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-frequalizer/external/Frequalizer \
		build-single-app

build-odin2:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-odin2 \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-odin2/external/odin2 \
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

build-witte-eq:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-witte-eq \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-witte-eq/external/Eq \
		build-single-app

build-chow-phaser:
	make \
		APP_TARGET=$(PWD)/apps/aap-juce-chow-phaser \
		APP_SRC_DIR=$(PWD)/apps/aap-juce-chow-phaser/external/ChowPhaser \
		build-single-app

