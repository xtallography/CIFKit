.PHONY: docs clean xcodeproj


docs: 
	jazzy --clean \
		--xcodebuild-arguments -scheme,CIFKit-Package \
		--module CIFKit


xcodeproj:
	export PKG_CONFIG_PATH=/usr/local/opt/icu4c/lib/pkgconfig
	swift package generate-xcodeproj --enable-code-coverage --xcconfig-overrides Configs/*.xcconfig
