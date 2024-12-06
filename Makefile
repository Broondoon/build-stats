# Variables
PLATFORM ?= windows
APP_PATH = .\app\build\${PLATFORM}\x64\runner\Release
APP_BINARY = ${APP_PATH}\build_stats_flutter.exe
APP_BUILD_FLAG = ${APP_PATH}\build_complete
SERVER_PATH = .\server\bin
SERVER_BINARY = ${SERVER_PATH}\server.exe
SERVER_BUILD_FLAG = ${SERVER_PATH}\build_complete

# Targets
do_setup:
	@echo "Setting up project"
	@cd ./app/ && flutter clean && flutter pub get

build_server:
	@echo "Compiling server"
	@cd ./server/ && dart pub get && dart compile exe bin/server.dart
	@echo > $(SERVER_BUILD_FLAG)

build_app: do_setup
	@echo "Compiling ${PLATFORM} app"
	@cd ./app/ && flutter build ${PLATFORM} --release
	@echo > $(APP_BUILD_FLAG)

clean:
	@echo "Cleaning build artifacts"
	@if exist $(SERVER_BINARY) del /q $(SERVER_BINARY)
	@if exist $(SERVER_BUILD_FLAG) del /q $(SERVER_BUILD_FLAG)
	@cd ./app/ && flutter clean
	@echo "Clean complete."

start_server:
	@echo "Starting server"
	@cmd /k "cd server/bin && start server.exe"

start_app_instances:
	@echo "Starting app instance 1"
	@cd ${APP_PATH} && start build_stats_flutter.exe
	@echo "Starting app instance 2"
	@cd  ${APP_PATH} && start build_stats_flutter.exe

demo: 
    @echo "Starting demo"
    @$(MAKE) start_app_instances
    @$(MAKE) start_server

full_demo: 
ifeq ($(wildcard $(SERVER_BUILD_FLAG)),)
	@$(MAKE) build_server
endif
ifeq ($(wildcard $(APP_BUILD_FLAG)),)
	@$(MAKE) build_app
endif
	@echo "Starting demo"
	@$(MAKE) start_app_instances
	@$(MAKE) start_server


stop_demo:
	@echo "Stopping all processes"
	@taskkill /F /IM server.exe || echo "Server not running"
	@taskkill /F /IM build_stats_flutter.exe || echo "App instances not running"
