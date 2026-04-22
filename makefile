.PHONY: build run

build:
	@echo "Building project..."
	build.bat

run: build
	@echo "Running project..."
	run.bat