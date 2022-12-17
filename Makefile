export PATH := $(GOPATH)/bin:$(PATH)
export GO111MODULE=on
LDFLAGS := -s -w

ndk=/Users/xxx/Library/Android/sdk/ndk-bundle/toolchains/llvm/prebuilt/darwin-x86_64/bin
android-386=${ndk}/i686-linux-android30-clang
android-amd64=${ndk}/x86_64-linux-android30-clang
android-arm=${ndk}/armv7a-linux-androideabi30-clang
android-arm64=${ndk}/aarch64-linux-android30-clang

os-archs=android-386 android-amd64 android-arm android-arm64 darwin-amd64 darwin-arm64 linux-386 linux-amd64 linux-arm linux-arm64 windows-386 windows-amd64

build:
	@$(foreach n, $(os-archs),\
		os=$(shell echo "$(n)" | cut -d - -f 1);\
		arch=$(shell echo "$(n)" | cut -d - -f 2);\
		target_suffix=$${os}_$${arch};\
		echo "Build $${os}-$${arch}...";\
		env CGO_ENABLED=$(if $${os}=android,1,0) CC=$(if $${os}=android,${$(shell echo "$(n)")},) GOOS=$${os} GOARCH=$${arch} go build -trimpath -ldflags "$(LDFLAGS)" -o ./release/FileMonitor_$${target_suffix};\
		echo "Build $${os}-$${arch} done";\
	)
	@mv release/FileMonitor_windows_386 release/FileMonitor_windows_386.exe
	@mv release/FileMonitor_windows_amd64 release/FileMonitor_windows_amd64.exe

clean:
	$(RM) -rf ./release/