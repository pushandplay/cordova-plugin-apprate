SHELL = /bin/sh



DIR_SRC = ./www_src
DIR_BUILD = ./www
DIR_DEMO = ../AppRateDemoProject

.PHONY: all prepare coffee clean app_prepare

all: prepare coffee clean app_prepare
release: all compress
	@echo "\n\033[32mComplete\033[0m\n"

prepare:
	@echo "\n\033[32mPrepare $(DIR_BUILD) directory...\033[0m"
	@rm -rf $(DIR_BUILD) && mkdir $(DIR_BUILD)
	@rsync -av $(DIR_SRC)/ $(DIR_BUILD)


coffee:
	@echo "\033[32mCompile COFFEESCRIPT...\033[0m"
	@find $(DIR_BUILD)/ -name '*.coffee' -exec coffee -b -c {} \;
	@find $(DIR_BUILD)/ -name '*.coffee' -delete


clean:
	@echo "\033[32mClean $(DIR_BUILD) directory...\033[0m"
	@find $(DIR_BUILD)/ -type d -empty -delete


compress:
	@echo "\033[32mCompress files...\033[0m"
	@find $(DIR_BUILD) -name '*.js' -exec uglifyjs {} -o {} -c -m -d \;


app:
	@echo "\033[32mCreating demo project...\033[0m"
	@rm -rf $(DIR_DEMO) && mkdir $(DIR_DEMO)
	@cordova create $(DIR_DEMO) org.pushandplay.cordova.AppRateDemoProject AppRateDemoProject
	@#cd $(DIR_DEMO) && cordova plugins add https://github.com/pushandplay/cordova-plugin-apprate.git
	@cd $(DIR_DEMO) && cordova plugins add ../cordova-plugin-apprate
	@cd $(DIR_DEMO) && cordova platform add ios
	@cd $(DIR_DEMO) && cordova prepare


app_prepare:
	@echo "\033[32mPreparing demo project...\033[0m"
	@cd $(DIR_DEMO) && cordova plugins remove org.pushandplay.cordova.apprate
	@cd $(DIR_DEMO) && cordova plugins add ../cordova-plugin-apprate
	@cd $(DIR_DEMO) && cordova prepare


app_install:
	@cd $(DIR_DEMO) && cordova prepare
	@cd $(DIR_DEMO) && cordova run --device android


publish:
	@plugman publish ./