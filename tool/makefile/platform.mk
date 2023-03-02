ifeq ($(OS),Windows_NT)
	include tool/makefile/platform/win.mk
else
    _detected_OS := $(shell uname -s)
    include tool/makefile/platform/nix-shared.mk
    ifeq ($(_detected_OS),Linux)
		include tool/makefile/platform/nix.mk
    else ifeq ($(_detected_OS),Darwin)
		include tool/makefile/platform/mac.mk
    endif
endif