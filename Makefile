SHELL = /bin/sh



DIR_SRC = ./www_src
DIR_BUILD = ./www

.PHONY: all prepare coffee clean

all: prepare coffee clean
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
	@find $(DIR_BUILD)/* -name '*.js' -exec uglifyjs {} -o {} -c -m -d \;